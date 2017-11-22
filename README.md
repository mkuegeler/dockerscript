# dockerscript

Download and call the script with these parameters:
- Parameter 0 'build': build a new image. Write parameters in 'build.json' and call 'dockerscript.ps1 build'
- Parameter 1 'run': run a container. Write parameters in 'run.json' and call 'dockerscript.ps1 run' 
- Parameter 2 'exec': connect to a container. Write parameters in 'exec.json' and call 'dockerscript.ps1 exec' 
- Parameter 3 'commit': commit a container to an image. Write parameters in 'commit.json' and call 'dockerscript.ps1 commit' 
- Parameter 4 'push': push an image to a repository on Dockerhub. Write parameters in 'push.json' and call 'dockerscript.ps1 push' 
