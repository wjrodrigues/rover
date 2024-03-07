# frozen_string_literal: true

module Vehicle
  class LoaderFile < Callable
    attr_accessor :reader, :path, :dto, :dtos

    LIMIT_FILE_SIZE = 100

    ERRORS = {
      invalid_path: 'services.loader.invalid_path',
      invalid_format: 'services.loader.invalid_format',
      large_file: 'services.loader.large_file',
      invalid_content: 'services.loader.invalid_content'
    }.freeze

    def initialize(path:, reader: Files::Reader, dto: Vehicle::Dto)
      self.path = path
      self.reader = reader.new(path)
      self.dto = dto
      self.dtos = []

      super
    end

    # rubocop:disable Metrics/AbcSize
    def call
      reader.open!

      return add_error(:large_file) if large_file?

      parse_file!

      return add_error(:invalid_content) if dtos.empty?

      response.result!(dtos)
    rescue Files::Error::InvalidPhat
      response.error!(ERRORS[:invalid_path])
    rescue Files::Error::InvalidExtension
      response.error!(ERRORS[:invalid_format])
    end
    # rubocop:enable Metrics/AbcSize

    private

    def add_error(key) = response.error!(ERRORS[key])

    def large_file? = File.stat(path).size > LIMIT_FILE_SIZE

    def select_value(values, line)
      case line
      when Regex::INITIAL_POSITION, Regex::MOVEMENT
        values << line
      end
    end

    def new_dto(values) = dtos << Vehicle::Dto.new(values)

    def parse_file!
      dimension = reader.readline
      limit_size = 2
      values = []

      while reader.readline
        select_value(values, reader.line)

        next unless values.size == limit_size

        new_dto(values.push(dimension))

        values = []
      end
    end
  end
end
