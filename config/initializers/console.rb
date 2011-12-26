require 'irb'

module IRB
  def self.start_session(binding)
    IRB.setup(nil)

    workspace = WorkSpace.new(binding)

    if @CONF[:SCRIPT]
      irb = Irb.new(workspace, @CONF[:SCRIPT])
    else
      irb = Irb.new(workspace)
    end

    @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
    @CONF[:MAIN_CONTEXT] = irb.context

    trap("SIGINT") do
      irb.signal_handle
    end

    catch(:IRB_EXIT) do
      irb.eval_input
    end
  end
end

def console_for(bounding)
  puts "== ENTERING CONSOLE MODE. ==\nType 'exit' to move on.\n"

  begin
    oldargs = ARGV.dup
    ARGV.clear
    IRB.start_session(bounding)
  ensure
    ARGV.replace(oldargs)
  end
end
