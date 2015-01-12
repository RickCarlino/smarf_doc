class DocYoSelf
  @@tests = {}
  @@lock = ::Mutex.new
  attr_accessor :request, :response, :note, :file, :skip

  # == Usage
  # doc_yo_self = DocYoSelf.new
  # doc_yo_self.run!(self)
  #
  def run!(caller, options = {})
    @file = options[:output_file]
    @request = options[:request] 
    @response = options[:response] 
    @note = options[:note]

    if caller
      @file ||= caller.class.name.underscore.gsub('/', '_').sub(/_test$/,'') + '.md'
      @request ||= caller.request
      @response ||= caller.response
      @note ||= caller.method_name.sub(/^test[\d_]*/, '').gsub('_', ' ')
    end
    @file ||= self.class::Conf.output_file

    add_to_tests
  end

  def skip!
    @skip = true
  end

  def add_to_tests
    return if skip
    raise "No DocYoSelf output_file specified" if file.blank?

    if file[/\//]
      file_path = file #legacy support
    else
      folder = self.class::Conf.output_folder.try(:sub, /\/$/, '')
      raise "No DocYoSelf output_folder specified" if folder.blank?
      file_path = "#{folder}/#{file}" 
    end
    @@lock.synchronize do
      @@tests[file_path] ||= []
      @@tests[file_path] << self
    end
  end

  def compile_template
    template = self.class::Conf.template
    raise "No DocYoSelf template specified" unless template
    ERB.new(template).result binding
  end

  # START CLASS METHODS
  class << self
    def tests
      @@tests
    end

    def clean_up!
      @@lock.synchronize do
        @@tests = {}
      end
    end

    def sort_by_url(tests)
      tests.sort! do |x, y|
        x.request.path <=> y.request.path
      end
    end

    def output_testcases_to_file
      tests.each do |file, tests|
        File.delete file if File.exists? file
        File.open(file, 'a') do |file|
          sort_by_url(tests).each do |test|
            file.write(test.compile_template)
          end
        end
      end
    end

    def finish!
      output_testcases_to_file
      clean_up!
    end

    #Legacy Support
    def old_run!(request, response, output_file = nil)
      run!(nil, request: request, response: response, output_file: output_file)
    end

    def config(&block)
      yield(self::Conf)
    end
  end
  # END CLASS METHODS
end
