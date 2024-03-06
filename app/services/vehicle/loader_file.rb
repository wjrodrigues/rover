# frozen_string_literal: true

module Vehicle
  class LoaderFile < Callable
    attr_accessor :reader, :path, :dtos

    LIMIT_FILE_SIZE = 100

    ERRORS = {
      invalid_path: 'file not found',
      invalid_format: 'unsupported format',
      large_file: 'file size is invalid',
      invalid_content: 'file content is not valid'
    }.freeze

    def initialize(path:, reader: Files::Reader)
      self.path = path
      self.reader = reader.new(path)
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

    def new_dto_rover(values) = dtos << Vehicle::DtoRover.new(values)

    def parse_file!
      dimension = reader.readline
      limit_size = 2
      values = []

      while reader.readline
        select_value(values, reader.line)

        next unless values.size == limit_size

        new_dto_rover(values.push(dimension))

        values = []
      end
    end
  end
end
