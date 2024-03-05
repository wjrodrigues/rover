# frozen_string_literal: true

module Files
  class Reader
    attr_accessor :path, :file, :line

    private :path=, :file=, :file, :line=

    EXTENSIONS = %w[.txt].freeze

    def initialize(path)
      self.path = path
    end

    def open!
      return unless file.nil?

      raise Files::Error::InvalidPhat unless File.exist?(path)
      raise Files::Error::InvalidExtension unless valid?

      self.file = File.open(path)

      self
    end

    def readline
      self.line = file.readline.chomp
    rescue EOFError
      nil
    end

    private

    def valid? = EXTENSIONS.include?(File.extname(path))
  end
end
