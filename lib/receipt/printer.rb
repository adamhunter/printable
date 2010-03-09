module Receipt
  class Printer
  
    def self.print(*args, &block)
      unless block_given?
        printee, path = args[0], args[1]
        raise PaperJam.new("There is no receipt template at #{path}. Load paper in tray 1 and press resume.") unless FileTest.exists?(path)
        block = eval(File.read(path))
        new(printee, &block)
      else
        block
      end
    end
    
    attr_accessor :printee
    
    def initialize(printee, &block)
      @backgrounds, @pages, @printee = {}, {}, printee
      instance_exec(&block)
      print
    end
    
    def background(*args)
      number, file = extract_pagenumber(args)
      @backgrounds[number] = file
    end
    alias :back :background
    
    def page(*args)
      number, map = extract_pagenumber(args)
      @pages[number] = map
    end
    
    def print
      print_pages!
      merge_pages!
    end
   
    class PaperJam < StandardError ; end
    class CommandFailed < StandardError ; end
    
    protected
      # stinky...
      def print_pages!
        @pages.each_pair do |page_no, page|
          pdf = Prawn::Document.new(:margin => 0)
          page.each_pair do |attr, at|
            pdf.draw_text @printee.send(attr), :at => at
          end
          pdf.render_file(file_name page_no, 'temp')
          command = "pdftk #{file_name page_no, 'temp'} background #{@backgrounds[page_no]} output #{file_name page_no}"
          `#{command}`
          raise CommandFailed.new("Command: #{command} failed with status #{$?}.") unless $?.to_i.zero?
        end
        clean_pages!
      end
      
      def clean_pages!
        FileUtils.rm_r @pages.keys.collect { |page_no| file_name(page_no, 'temp') }
      end
      
      def merge_pages!
        command = "pdftk #{@pages.keys.collect { |page_no| file_name(page_no) }.join(' ')} cat output #{printee.class.name.downcase}.pdf"
        `#{command}`
        raise CommandFailed.new("Command: #{command} failed with status #{$?}.") unless $?.to_i.zero?
        FileUtils.rm_r @pages.keys.collect { |page_no| file_name(page_no) }
      end
      
      def file_name(page_no, prefix = nil)
        "#{prefix}#{printee.class.name.downcase}-#{page_no}.pdf"
      end
    
    private
      
      def extract_pagenumber(args)
        args.first.is_a?(Fixnum) ? [args[0], args[1]] : [1, args[0]]
      end
    
  end
end