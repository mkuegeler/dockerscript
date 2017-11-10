# Simple docker powershell script for docker process automation
# Author: Michael Kuegeler mkuegeler@gmail.com 2017

# running as powershell script with parameters
# call: 'powershell.exe -file dockerps.ps1' or just './dockerps.ps1' for help

# for docker reference see here:
# https://docs.docker.com/engine/reference/builder/

# get first argument as indicator for subsequent actions
$opts = $args[0]
# get second argument as json file with parameters
$file = $args[1]

# Call help (default if no parameters)
function help () {

    $helpContent = @(
        "PLEASE CALL THE SCRIPT WITH THESE PARAMETERS:",
        "-- Parameter 0 'build': build a new image. Write parameters in 'build.json' and call 'dockerscript.ps1 build' ",
        "-- Parameter 1 'run': run a container. Write parameters in 'run.json' and call 'dockerscript.ps1 run' ",
        "-- Parameter 2 'exec': connect to a container. Write parameters in 'exec.json' and call 'dockerscript.ps1 exec' ",
        "-- Parameter 3 'commit': commit a container to an image. Write parameters in 'commit.json' and call 'dockerscript.ps1 commit' ",
        "-- Parameter 4 'push': push an image to a repository on Dockerhub. Write parameters in 'push.json' and call 'dockerscript.ps1 push' "        
    )
    
    foreach ($item in $helpContent) {
        echo "`n$($item)`n"
    }
    
}
# read json parameter file
function getParameters ($file) {
    
    # default return value
    $json = $null
    
    if ($file) {       
        
        if (Test-Path -EA Stop $file) {
            $json = Get-Content -Raw $file | Out-String | ConvertFrom-Json             

        }     
        
    }      
    return $json
}

# Parameter 0: build a new image
function build ($p) { 
    
        $helpContent = @(
            "0. BUILD A NEW IMAGE",
            "Provide values for these parameters in 'build.json':"
            "-- dockerfile",
            "-- image"            
        )
           
        if (getParameters($p) -ne $null) {
              $json = getParameters($p)
              # execute docker command                        
              docker build -f $json.dockerfile -t $json.image .                 
        } else 
         {
            foreach ($item in $helpContent) {
                echo "`n$($item)`n"
            }
        }      
    }

# Parameter 1: run a container
function run ($p) {
    
        $helpContent = @(
            "1. RUN A CONTAINER",
            "Provide values for these parameters in 'run.json':"
            "-- Parameter 0: container name",
            "-- Parameter 1: image",
            "-- Parameter 2: host port. host->container",
            "-- Parameter 3: container port. host->container",
            "-- Parameter 4: hostdir",
            "-- Parameter 5: containerdir",
            "-- Parameter 6: command"                  
        )

        if (getParameters($p) -ne $null) {
            $json = getParameters($p)
            # execute docker command 
            # echo $json                       
            # docker run -h $json.container --name $json.container -i -t -d -p $json.hostport:$json.containerport -v $json.hostdir:$json.containerdir $json.image $json.command 
            $hostport = $json.hostport
            $containerport = $json.containerport

            ## volumes are optional
            if ($hostdir) {
                $hostdir = $json.hostdir
                $containerdir = $json.containerdir
                docker run -h $json.container --name $json.container -i -t -d -p  ${hostport}:${containerport} -v ${hostdir}:${containerdir} $json.image $json.command
                
            }

            else {
                docker run -h $json.container --name $json.container -i -t -d -p  ${hostport}:${containerport} $json.image $json.command    
            }

                            
      } else 
       {
          foreach ($item in $helpContent) {
              echo "`n$($item)`n"
          }
      } 
   
    }
    # Parameter 2:connect to a container
function exec ($p) {
    
        $helpContent = @(
            "2. CONNECT TO A CONTAINER",
            "Provide values for these parameters in 'exec.json':"
            "-- Parameter 0: container name" 
            "if the docker container was started using /bin/bash command, you can access it using attach. The container stops if you exit the command.", 
            "if not then you need to execute the command to create a bash instance inside the container using exec."               
        )

        if (getParameters($p) -ne $null) {
            $json = getParameters($p)
            # execute docker command                                  
            docker exec -it $json.container $json.command                 
      } else 
       {
          foreach ($item in $helpContent) {
              echo "`n$($item)`n"
          }
      } 
        
       
    }
# Parameter 3: commit a container to a new image
function commit ($p) {
    
        $helpContent = @(
            "3. COMMIT A CONTAINER TO A NEW IMAGE",
            "Provide values for these parameters in 'commit.json':"
            "-- Parameter 0: container name",
            "-- Parameter 1: new image name"                           
        )
        if (getParameters($p) -ne $null) {
            $json = getParameters($p)
            # execute docker command                                
            docker commit -p $json.container $json.image                 
      } else 
       {
          foreach ($item in $helpContent) {
              echo "`n$($item)`n"
          }
      }  
        
    } 
 # Parameter 4: push an image to a repository on Dockerhub
function push ($p) {
    
        $helpContent = @(
            "4. PUSH AN IMAGE TO A REPOSITORY ON DOCKERHUB",
            "Provide values for these parameters in 'push.json':"
            "-- Parameter 0: local image",
            "-- Parameter 1: repo image"                           
        )
        if (getParameters($p) -ne $null) {
            $json = getParameters($p)
            # execute docker command 
            docker tag $json.localimage $json.repoimage
            docker push $json.repoimage                     
                            
      } else 
       {
          foreach ($item in $helpContent) {
              echo "`n$($item)`n"
          }
      } 
       
    } 
        
# check parameter input
# call json without '.json' extension
switch ($opts) {    
    0 {build($file+".json")} 
    1 {run($file+".json")}
    2 {exec($file+".json")}
    3 {commit($file+".json")}
    4 {push($file+".json")}        
    Default {help}
}



