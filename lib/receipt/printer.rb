module Receipt
  class Printer
  
    def self.print(printee, path)
      raise PaperJam.new("There is no receipt template at #{path}. Load paper in tray 1 and press resume.") unless FileTest.exists?(path)
      new(printee, &eval(File.read(path)))
    end
    
    def self.receipt(&block)
      block
    end
    
    attr_accessor :printee
    
    def initialize(printee, &block)
      @backgrounds, @pages, @basepath, @printee = {}, {}, '.', printee
      instance_exec(&block)
      print
    end
    
    def background(*args)
      number, file = extract_pagenumber(args)
      Array(number).each { |n| @backgrounds[n] = file }
    end
    alias :back :background
    
    def page(*args)
      number, map = extract_pagenumber(args)
      @pages[number] = map
    end
    
    def base(path)
      @basepath = File.expand_path(path)
      FileUtils.mkdir_p(@basepath)
    end
    
    def print
      print_pages!
      merge_pages!
      clean_pages!
    end
   
    class PaperJam < StandardError ; end
    class CommandFailed < StandardError ; end
    
    protected
    
      def print_pages!
        @pages.each_pair do |page_no, page|
          pdf = print_page(page)
          pdf.render_file temp_file_path(page_no)
          run "#{temp_file_path(page_no)} background #{File.expand_path(@backgrounds[page_no])} output #{file_path(page_no)}"
        end
      end
      
      def merge_pages!
        merge = @pages.keys.collect { |page_no| file_path(page_no) }.join(' ')
        run "#{merge} cat output #{file_path}"
      end
      
      def clean_pages!
        FileUtils.rm_r @pages.keys.collect { |page_no| [temp_file_path(page_no), file_path(page_no)] }.flatten
      end
      
      def print_page(page)
        pdf = Prawn::Document.new(:margin => 0)
        page.each_pair do |attr, at|
          pdf.draw_text @printee.send(attr), :at => at
        end
        pdf
      end
      
      def file_name(page_no)
        "#{page_no}#{printee.class.name.downcase}-#{printee.id}.pdf"
      end
      
      def file_path(page_no = nil)
        File.join(@basepath, file_name(page_no))
      end
      
      def temp_file_path(page_no)
        File.join(@basepath, "temp#{file_name(page_no)}")
      end
      
      # todo: specify path to bin
      def run(command)
        `pdftk #{command}`
        raise CommandFailed.new("Command: `pdftk #{command}` failed with status #{$?}.") unless $?.to_i.zero?
      end
    
    private
      
      def extract_pagenumber(args)
        args.size == 1 ? [1, args[0]] : [args[0], args[1]]
      end
    
  end
end