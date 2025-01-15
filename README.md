java-example-gradle-useversion
==============================

For a huge project, my team and myself
create lots of utility libraries (libs) and publish
them to a maven repository. These libs
are used by other gradle projects.

<!--more-->

Goals
-----

- all gradle projects should use a "similar" version of the libs, i.e. '0.+'
- the version should be specified in a central place
- the number of libs may vary over time, i.e. we start with "hello-world",
  add "bye-moon" later on, add "maybe-mars" even later and so on

Contraints
----------

For other parts, I created a BOM project containing constraints
of various components, something like

- my-platform
  - build.gradle
    ```
    ...
    dependencies {
      constraints {
        api('cool.heller.xml:my-xml-reader:2.+')
        api('cool.heller.xml:my-xml-writer:3.+')
	...
      }
    }
    ```

I cannot use this approach for the libs, since
it would require to list all the available lists within
the constraints. I want the list to be variable!




Rough Plan
----------

- Create a local maven repository
- Publish two hava libraries to it
- Have a third java project

Create Local Maven Repository
-----------------------------

...

Problems
--------

### Adding dependencies after creating the lock

```
$ ./gradlew -b build-nodeps.gradle dependencies --write-locks
$ ./create-maven-repository.sh 1
$ ./gradlew build
> Task :compileJava FAILED

FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':compileJava'.
> Could not resolve all files for configuration ':compileClasspath'.
   > Resolved 'cool.heller.uli:hello-world:0.1.0' which is not part of the dependency lock state
   > Resolved 'cool.heller.uli:bye-moon:0.0.1' which is not part of the dependency lock state

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

BUILD FAILED in 1s
1 actionable task: 1 executed
```

### Using useVersion when new versions are available

- `create-maven-repository.sh`
- `./gradlew -b build-useversion.gradle dependencies --write-locks` -> version 0.0.0 shows up within the lockfiles
- `./gradlew -b build-useversion.gradle build` -> works
- `create-maven-repository.sh 1`
- `./gradlew -b build-useversion.gradle build` -> fails

  ```
  $ ./gradlew -b build-useversion.gradle build
  > Task :compileJava FAILED

  FAILURE: Build failed with an exception.

  * What went wrong:
  Execution failed for task ':compileJava'.
  > Could not resolve all files for configuration ':compileClasspath'.
   > Did not resolve 'cool.heller.uli:hello-world:0.0.0' which has been forced / substituted to a different version: '0.1.0'
   > Did not resolve 'cool.heller.uli:bye-moon:0.0.0' which has been forced / substituted to a different version: '0.0.1'

  * Try:
  > Run with --stacktrace option to get the stack trace.
  > Run with --info or --debug option to get more log output.
  > Run with --scan to get full insights.
  > Get more help at https://help.gradle.org.

  BUILD FAILED in 1s
  1 actionable task: 1 executed
  ```

- `./gradlew build` -> works

A possible solution:

```diff
--- build-useversion.gradle	2025-01-13 22:36:37.512069105 +0100
+++ build-useversion-2.gradle	2025-01-13 22:37:37.016185920 +0100
@@ -30,11 +30,14 @@
         }
 }
 
+def writeLocksFlag = project.hasProperty("writeLocks") ? writeLocks : false
+
 dependencies {
         implementation 'org.springframework.boot:spring-boot-starter-web'
-        implementation 'cool.heller.uli:hello-world:+'
-        implementation 'cool.heller.uli:bye-moon:+'
+        implementation 'cool.heller.uli:hello-world'
+        implementation 'cool.heller.uli:bye-moon'
 
+        if (writeLocksFlag) {
         configurations.all {
             resolutionStrategy.eachDependency {  DependencyResolveDetails details ->
                 if (details.requested.group.startsWith("cool.heller.uli")) {
@@ -45,3 +48,4 @@
             }
         }
 }
+}
```

With this:

- `create-maven-repository.sh`
- `./gradlew -b build-useversion-2.gradle dependencies --write-locks -PwriteLocks=true` -> version 0.0.0 shows up within the lockfiles
- `./gradlew -b build-useversion-2.gradle build` -> works
- `create-maven-repository.sh 1`
- `./gradlew -b build-useversion-2.gradle build` -> fails
