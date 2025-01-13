java-example-gradle-dependency-problems
=======================================

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
