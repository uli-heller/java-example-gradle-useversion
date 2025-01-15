java-example-gradle-useversion
==============================

For a huge project, my team and myself
create lots of utility libraries (libs) and publish
them to a maven repository. These libs
are used by other gradle projects.

<!--more-->

Goals
-----

- gradle projects may use the libs already, specifying bad versions for them.
  These should be overridden!
- all gradle projects should use a "similar" version of the libs, i.e. '0.+'
- the version should be specified in a central place
- the number of libs may vary over time, i.e. we start with "hello-world",
  add "bye-moon" later on, add "maybe-mars" even later and so on

Constraints
-----------

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

UseVersion
----------

build.gradle:

```
...
apply from:  'cool-heller-uli.gradle'
...
``

cool-heller-uli.gradle:

```
ext {
  coolHellerUliVersion='1.+'
}

allprojects {
  dependencies {
    configurations.all {
      resolutionStrategy.eachDependency { DependencyResolveDetails details ->
        if (details.requested.group == 'cool.heller.uli') {
          details.useVersion coolHellerUliVersion
        }
      }
    }
  }
}
```

Test procedure
--------------

```
rm -rf maven-repository
./create-maven-repository.sh 0 2
./create-maven-repository.sh 1 2
./gradlew build                                  # --> BUILD SUCCESSFUL
unzip -v build/libs/java*SNAPSHOT.jar|grep hello # --> hello-world-1.2.0-plain.jar
unzip -v build/libs/java*SNAPSHOT.jar|grep bye   # --> bye-moon-1.2.0-plain.jar
```

Works quite good!

- Latest version matching '1.+' is used
- Version '0.1.0' of hello-world is ignored
- Unspecified version for bye-moon works, too
