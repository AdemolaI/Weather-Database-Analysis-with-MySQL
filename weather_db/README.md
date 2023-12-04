#### Author: Meysam Torkaman
#### Date: 2021-01-27

# How to clone from the public Github Repo  
You can download the zip files and unzip it on your local PC.

Alternatively, you can also run bellow command on a Terminal on you PC:
Note that: you should already have Git Version Control installed on you PC. 
If you need instructions to install Git please visit https://github.com/git-guides/install-git

```
git clone https://github.com/profusion-public/Data-Academy-SQL.git
git config core.ignorecase true
```



# How sql dump files are created:
The tables are dumped from weather_db database using mysqldump command. for example:
```
mysqldump --databases weather_db --tables cat_locations  --where="1 limit 10000"  -h <host_IP>  -u <user_name> -p<password> > cat_locations.sql
mysqldump --databases weather_db --tables metoffice_dailyweatherdata --where="1 and obs_dateTime >= '2020-01-01' and obs_dateTime >= '[NULL]' and obs_dateTime is not NULL limit 10000"  -h <host_IP>  -u <user_name> -p<password>  > metoffice_dailyweatherdata.sql
```


## How to fire up the container:
Before anything, you need to install **Docker** and **Docker-compose** on your computer.
Instructions at: https://docs.docker.com/get-docker/

- After installing Docker successfully, using Terminal please go to the project directory:
```
cd /path/to/directory
```
note: you need to share any mounted directory/volumes with your Docker.
Please go to **Preferences > Resources > FILE SHARING** (you can find this when you click on Docker icon on your PC),
and add the path to shared paths (e.g. ~/database/db_dumps), and click on "**Apply and Restart**",
wait until you see "**Docker is Running**" again.

- To start the container type:
```
docker-compose up -d
```
Note: This may take few minutes.
- Check the status of the Docker container by:
```
docker ps
docker container ls -a
```
- In case of a failure:
```
docker logs da_sql
```

- To stop and remove the container:
```
docker-compose down
docker-compose down -v  # remove mounted volume connection       
```
- to remove the image
```
docker images
docker image rm <image_id>
```
Note: To restart the container again just type **docker-compose up -d** again inside the project folder.
- To access mysql console on your Terminal:
```
docker exec -it da_sql /bin/bash
> mysql -u root -prootpass
>> show databases;
>> use weather_db;
>> SELECT * from metoffice_forecast_text limit 5;
...
```

## How to connect to the MySQL database on the Docker container:
Create a new MySQL connection on a local client (MySQL Workbench, DBeaver, etc) using these credentials:
```
host: localhost
port: 3306
Database: weather_db
Username: dbuser
Password: userpass
```
you can also use above credentials to connect from Python as well.


- Any changes made to the database would be saved and will be accessible even after container restart.
  you may lose data if you delete the mount connection using:
```
docker-compose down -v
```
