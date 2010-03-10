module Printable
  class Printer
    
    attr_accessor :printee
    
    def initialize(printee, path)
      @backgrounds, @pages, @basepath, @printee = {}, {}, '.', printee
      load_template(path) unless path.nil?
    end
    
    def printable(&block)
      block.call
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
        FileUtils.rm_rf @pages.keys.collect { |page_no| [temp_file_path(page_no), file_path(page_no)] }.flatten
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
      
      def run(command)
        `#{execute = "#{bin} #{command} > #{logger}"}`
        raise PaperJam.new("Command: `#{execute}` failed with status #{$?}.") unless $?.to_i.zero?
      end
      
      def bin
        "#{Printable.options[:command_path]}pdftk"
      end
      
      def logger
        Printable.options[:command_logger]
      end
      
      def load_template(path)
        path = File.expand_path(path)
        raise OutOfPaper.new("There is no printable template at #{path}. Load paper in tray 1 and press resume.") unless FileTest.exists?(path)
        eval(File.read(path))
      end
    
    private
      
      def extract_pagenumber(args)
        args.size == 1 ? [1, args[0]] : [args[0], args[1]]
      end
      
    class PaperJam < StandardError ; end
    class OutOfPaper < StandardError ; end
    
  end
end