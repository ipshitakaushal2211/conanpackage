from conan import ConanFile

class IWTestAutomationPackage(ConanFile):
    name = "IWTestAutomation"
    version = "1.0"
    exports_sources = "package_contents/*"
    no_copy_source = True

    def package(self):
        self.copy("*", dst="build", src="package_contents/build")
        self.copy("*", dst="output", src="package_contents/output")
