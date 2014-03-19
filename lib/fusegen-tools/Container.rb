require "pp"
#TODO:
#  - get from repo
#  - bump memory
#  - add user
#  - install all features
#  - add patches


class Container
  def initialize(installDir,parentUser,parentPassword)
    #@JBOSS_INSTALL_DIR = "/Users/sjavurek/Fuse/JBossFuse/6.1/jboss-fuse-6.1.0.redhat-328"
    #@JBOSS_INSTALL_DIR = "/Users/sjavurek/Fuse/JBossFuse/6.0/jboss-fuse-6.0.0.redhat-024"
    #@JBOSS_INSTALL_DIR = "/Users/sjavurek/Fuse/JBossFuse/6.1/jboss-fuse-6.1.0.redhat-361"
    @JBOSS_INSTALL_DIR = installDir
    @PARENT_USER       = parentUser
    @PARENT_PASSWORD   = parentPassword
    @CLIENT_DIR        = "#{@JBOSS_INSTALL_DIR}/bin/client"
    @CLIENT            = "#{@CLIENT_DIR} -u #{@PARENT_USER} -p #{@PARENT_PASSWORD}"

  end
  
  def installParent(repo)
      system "cd @JBOSS_INSTALL_DIR"
      system "wget repo"
      system "gunzip repo"
      system "tar xvf repo"
  end
  
  #TODO determine if child
  def start(name,clean)
    
    @cmd = @JBOSS_INSTALL_DIR +"/bin/start"
    if clean == "clean"
       @cmd = @cmd + " clean"
    end
    
    puts @cmd
    system "#{@cmd}"
  end
  
  # TODO: determine if child
 
  def stop(name)
    @cmd = @JBOSS_INSTALL_DIR + "/bin/stop"
    puts @cmd
    system "#{@cmd}"   
  end
  
  
  #
  # Returns a list of uninstalled fatures in an array
  def getUninstalledFeatures()
    @cmd = " #{@CLIENT}" +  " \"features:list |grep uninstalled\""
    puts " -- #{@cmd}"
    
    # .split('\n')
    return `#{@cmd}`.split("\n")    
  end
  
  #
  # Installs feature specified in parameter
  def installFeature(feature)
    @cmd = " #{@CLIENT}" + " \"features:install " + feature + "\"" 
    puts @cmd 
    `#{@cmd}`
    
    #@cmd= " #{@CLIENT}" + " \"features:list |grep " + feature + "\""
    #p `#{@cmd}`
  end

  # 
  # Loop through list of un-installed non-fabric features and install them
  def installUninstalledFeatures(container, skipList)
   
    features = container.getUninstalledFeatures
     puts  skipList.length()
    #puts features.length
    #puts features
    # Install all features except fabric ones 
    skipped = Array.new
    features.each_with_index do | line, index |
    
     skip=false
      if line.rindex("]") != nil
        f =  "#{line}"[("#{line}".rindex("]") +2).."#{line}".length].split("\s")[0]
  
        skipList.each do |item|
         if f.include? item
         # puts " ** Skipping"
           skipped.push(f)
           skip = true
         end
        end
        if skip == false
         container.installFeature("#{f}")
         #puts "installing " +  "#{f}"
       end
     
    end
   end
   
   #puts container.getUninstalledFeatures().length
   puts "Skipped #{skipped.length}: "
   pp skipped
    
  end
  

    
  #
  # Adds patch file and installs it
  def installPatch(file, name)
    @cmd = " #{@CLIENT}" + " \"patch:list\""
    list =  `#{@cmd}`
    
   # if list.match(/name/i) 
   #    puts "Patch, #{name} already added. Skipping add."
   # else
    
       @cmd = " #{@CLIENT}" + " \"patch:add file://" + file + "\"" 
        puts @cmd
       `#{@cmd}`
    #end

    @cmd = " #{@CLIENT}" + " \"patch:install " + name + "\"" 
    puts @cmd
    `#{@cmd}`
    sleep(10)
     runOsgiCommand("patch:list") 
  end
  
  #
  # admin:create --ssh-port 5201 --rmi-registry-port 5221 --rmi-server-port 5211 imgateway
  #
  def createChild(name, sshPort, rmiRegistryPort, rmiServerPort)
    @cmd = " #{@CLIENT}" + " \"admin:create --ssh-port " + sshPort  +
                         " --rmi-registry-port " + rmiRegistryPort + 
                         " --rmi-server-port "  + rmiServerPort  +
                         " " + name + "\""
    
    puts @cmd
    
    # Check if ports/name in use
    @cmd2 = " #{@CLIENT}" + " \" admin:list\""
    list = `#{@cmd2}`
    if list.match(/#{name}/i) or 
       list.match(/#{sshPort}/i)  or 
       list.match(/#{rmiRegistryPort}/i) or
       list.match(/#{rmiServerPort}/i)
         puts
         puts " *** Child not created. Port/name combination already in use. Please try again."
         puts ""

    else             
       `#{@cmd}`
    end
  end
 
  def runOsgiCommand(command) 
    @cmd = " #{@CLIENT}" + " \"" + command + "\"" 
    puts @cmd
    system @cmd
  end
     
    
end

# ******** START SCRIPT *********

 #puts " *** Getting List"
 #p `date`
 #container = Container.new()
# container.installUninstalledNonFabricFeatures()
 #container.installPatch
 #container.createChild("test", "5201","5211", "5221")
 #container.runOsgiCommand("admin:list")
 
 #container.installPatch("/Users/sjavurek/Fuse/Patches/GradleTester/target/patches/activemq.zip", "activemq-patch")
  
 
 
 