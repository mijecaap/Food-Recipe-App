// buildscript {
//     ext.kotlin_version = '1.8.20'
//     repositories {
//         google()
//         mavenCentral()
//     }

//     dependencies {
//         classpath 'com.android.tools.build:gradle:7.2.0'
//         classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
//     }
// }

// allprojects {
//     repositories {
//         google()
//         mavenCentral()
//     }
// }

// rootProject.buildDir = '../build'
// subprojects {
//     project.buildDir = "${rootProject.buildDir}/${project.name}"
// }
// subprojects {
//     project.evaluationDependsOn(':app')
// }

// tasks.register("clean", Delete) {
//     delete rootProject.layout.buildDirectory
// }
allprojects {
    repositories {
        google()
        mavenCentral()
    }
    gradle.projectsEvaluated {
        tasks.withType<JavaCompile> {
            options.compilerArgs.add("-Xlint:deprecation")
        }
    }   
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}