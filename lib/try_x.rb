##
# try_x implements a mechanism to attempt something x number of times
# logging an error message and continuing
# handy for req/res timeouts
module Try_x

    def try_x( info_msg, most = 3)
      retval = false
      attempts = 0
      while attempts < most + 1
        begin
          retval = yield
          attempts = 0
          break
        rescue
          attempts += 1
          msg =  "attempt #{attempts} failed while #{info_msg}"
          puts msg
          
          if attempts > most
            puts "logging Error"
            # logger.debug msg + "\n" + $!.to_s
            puts $!.to_s
            $@.each { |line| puts line}
          end

        end
      end
      retval
    end  
  end