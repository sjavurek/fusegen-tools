
require "Container.rb"

#./target/patches/fabric-zookeeper.zip 
#./target/patches/fabric.zip   
def installPatches(container)
  container.installPatch("/Users/sjavurek/Fuse/Patches/GradleTester/target/patches/activemq.zip", "activemq-patch")
  container.installPatch("/Users/sjavurek/Fuse/Patches/GradleTester/target/patches/camel.zip", "camel-patch")
  container.installPatch("/Users/sjavurek/Fuse/Patches/GradleTester/target/patches/hawtio.zip", "hawtio-patch")
  container.installPatch("/Users/sjavurek/Fuse/Patches/GradleTester/target/patches/karaf.zip", "karaf-patch")
  container.installPatch("/Users/sjavurek/Fuse/Patches/GradleTester/target/patches/patch.zip", "patch-patch")
  container.installPatch("/Users/sjavurek/Fuse/Patches/GradleTester/target/patches/sp1.zip", "sp1-patch")
end

def rolbackPatches(container)
  
  container.runOsgiCommand("patch:rollback activemq-patch")
  container.runOsgiCommand("patch:rollback camel-patch")
  container.runOsgiCommand("patch:rollback hawtio-patch")
  container.runOsgiCommand("patch:rollback karaf-patch")
  container.runOsgiCommand("patch:rollback patch-patch")
  container.runOsgiCommand("patch:rollback sp1-patch")
  
end

def simulatePatches(container)
  container.runOsgiCommand("patch:simulate activemq-patch")
  container.runOsgiCommand("patch:simuate camel-patch")
  container.runOsgiCommand("patch:simulate hawtio-patch")
  container.runOsgiCommand("patch:simulate karaf-patch")
  container.runOsgiCommand("patch:simulate patch-patch")
end


#*** START SCRIPT *****
  
puts " *** Getting List"
p `date`
container = Container.new("/Users/sjavurek/Fuse/JBossFuse/6.1/jboss-fuse-6.1.0.redhat-361","admin","admin")

# Scenario 1: Install patches with all features in place

skipList=["fabric","patch-client","gemini-blueprint","spring", "nmr", "jpa", "insight"]

#container.installUninstalledFeatures(container, skipList)
#installPatches(container)
#simulatePatches(container)
container.runOsgiCommand("list |grep 61036X")

#TODO: Auto verification

# Scenario 2: Install patches with default features in place then install all features

#container.stop()
#Sleep to give container chance stop
#contianer.start("clean")
#Sleep to give time container start
#installPatches(container)
#container.installUninstalledNonFabricFeatures()
# TODO: Auto verification

# restart container with clean - are patches still there?

#container.stop()
#container.start("root",true)

#Scenario 3: Rollback patches - verify they are not active
# Scneario 4: Rollback and re-install


