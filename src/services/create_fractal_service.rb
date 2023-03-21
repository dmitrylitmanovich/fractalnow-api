require 'tempfile'
require 'open3'

module Services
  class CreateFractalService
    attr_accessor :config, :config_file, :output_file

    DEFAULT_CONFIGS = [
      <<-CONFIG1
      c075
      mandelbrot
      -6.999999999999999555910790149937383830547E-01 0E+00
      3.857142857142857142857142857142857142859E+00 3E+00
      1000 1000
      1
      0x0
      iterationcount
      smooth
      log
      0.45 0.2
      0 0x39a0 0.25 0xffffff 0.5 0xfffe43 0.75 0xbf0800 1 0x39a0
      CONFIG1
    ]

    def initialize(config=nil)
      @config = config ? config : DEFAULT_CONFIGS.sample
      @config_file, @output_file = prepare_files
    end

    def call
      Open3.popen3(
        "fractalnow -x 3840 -y 2160 -c #{config_file.path} -o #{output_file.path}",
        err: :out) do |stdin, stdout, stderr|
        p stdout.read
      end

      output_file.read
    end

    private

    def config_file_create
      file = Tempfile.new("config.config")
      file.open.write(config)
      file.close
      file
    end

    def fractal_file_create
      Tempfile.new("fractal.ppm")
    end

    def prepare_files
      [
        config_file_create,
        fractal_file_create
      ]
    end
  end
end
