require '../lib/Utilities/Container.rb'

container = Container.new("/Users/sjavurek/Fuse/JBossFuse/6.0/jboss-fuse-6.0.0.redhat-024","admin","admin")
#container.installUninstalledNonFabricFeatures(container)

container.installFeature("cxf-wsn")
container.installFeature("cxf-wsn-api")


#container.installPatch("/Users/sjavurek/Fuse/Patches/JbossFuse/6.0/jboss-fuse-6.0.0.redhat-024-r1.zip",  "jboss-fuse-6.0.0.redhat-024-r1")
#container.installPatch("/Users/sjavurek/Fuse/Patches/JbossFuse/6.0/jboss-fuse-6.0.0.redhat-024-r1p3.zip", "jboss-fuse-6.0.0.redhat-024-r1p3")

container.runOsgiCommand("patch:list")
