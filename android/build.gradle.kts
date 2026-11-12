
import com.android.build.api.dsl.ApplicationExtension
import com.android.build.api.dsl.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory.dir("../../build").get()

rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory =
        newBuildDir.dir(project.name)

    project.layout.buildDirectory.value(newSubprojectBuildDir)

    project.evaluationDependsOn(":app")

    afterEvaluate {
        extensions.findByType(LibraryExtension::class.java)?.let {
            it.compileSdk = 37
        }

        extensions.findByType(ApplicationExtension::class.java)?.let {
            it.compileSdk = 37
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
