# Inception
`docker` 및 `docker compose`를 활용한 서비스 배포

| 구분 | 서비스 | 용도
| --- | --- | ---
| mandatory | mariadb | 데이터 저장 및 관리
| mandatory | wordpress | 웹 콘텐츠 관리 및 퍼블리싱
| mandatory | nginx | 웹 서버 호스팅 및 프록시
| bonus | redis | 캐싱 및 세션 관리
| bonus | ftp | 파일 전송 및 관리
| bonus | static web | 정적 파일 호스팅(이미지, CSS, ...)
| bonus | adminer | 데이터베이스 관리
| bonus | exim | 메일 서비스


## 사용법
```sh
$ make              # 이미지 생성 및 서비스 실행 
$ make bonus        # 이미지 생성 및 서비스 실행 (보너스 포함)
$ make clean        # 서비스 종료 및 이미지 제거
$ make fclean       # 볼륨 및 캐시 제거
$ make re           # fclean + all
```
- `https://localhost:443` 


## 설정 예시
```sh
$ cat src/.env
DOMAIN_NAME=minjungk.42.fr

# certificates
CERTS_=requirements/tools       # 인증서 위치 (해당 경로로 설정 시 Makefile에 의해 없으면 인증서 자동생성)

# MYSQL SETUP
MYSQL_USER=maria
MYSQL_DATABASE=wpdb
MYSQL_PASSWORD=mariapass
MYSQL_ROOT_PASSWORD=rootpass

# WORDPRESS SETUP
WORDPRESS_ADMIN_USER=minjungk
WORDPRESS_ADMIN_EMAIL=minjungk@student.42seoul.kr
WORDPRESS_ADMIN_PASSWORD=minjungkpass

WORDPRESS_USER=someone
WORDPRESS_EMAIL=somone@student.42seoul.kr
WORDPRESS_PASSWORD=someonepass

# FTP SETUP
FTP_USER=ftpuser
FTP_PASS=ftppass

# EXIM SETUP
EXIM_USER=exim
EXIM_PASS=eximpass
```

## 비고
- 워드프레스 댓글을 단 경우 이메일로 알림 메일이 전송된다.
- 이메일이 전달되지 않은 경우, 메일 서버(naver, google, ...)에 의해 스팸 메일함에 있거나 자동 삭제 처리 됐을 수 있다.
- 페이지 로딩이 느리거나 접속 중 `DNS_PROBE_FINISHED_NXDOMAIN` 오류가 발생한 경우 도메인명이므로 다음 중 하나를 수행한다.
  1. .env의 `DOMAIN_NAME`을 `localhost` 또는 실제 도메인으로 설정한다.
  2. `/etc/hosts` 또는 `C:\Windows\System32\drivers\etc\hosts` 파일에서 해당 도메인 명을 `localhost`로 설정한다.
      ```
      127.0.0.1 minjungk.42.fr
      ```
- 도메인 변경 후데이터베이스를 유지하고 싶은 경우 실제 데이터베이스에 하드코딩된 주소를 바꿔줘야 한다.
  ```
  $ docker exec -it mariadb sh
  $ mariadb
  MariaDB [(none)]> show databases;
  MariaDB [(none)]> use wpdb;

  MariaDB [(wpdb)]> show tables;
  MariaDB [wpdb]> desc wp_options;
  +--------------+---------------------+------+-----+---------+----------------+
  | Field        | Type                | Null | Key | Default | Extra          |
  +--------------+---------------------+------+-----+---------+----------------+
  | option_id    | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
  | option_name  | varchar(191)        | NO   | UNI |         |                |
  | option_value | longtext            | NO   |     | NULL    |                |
  | autoload     | varchar(20)         | NO   | MUL | yes     |                |
  +--------------+---------------------+------+-----+---------+----------------+
  4 rows in set (0.001 sec)
  
  MariaDB [wpdb]> select * from wp_options where option_name='siteurl' or option_name='home';
  +-----------+-------------+-----------------------+----------+
  | option_id | option_name | option_value          | autoload |
  +-----------+-------------+-----------------------+----------+
  |         1 | siteurl     | http://minjungk.42.fr | yes      |
  |         2 | home        | http://minjungk.42.fr | yes      |
  +-----------+-------------+-----------------------+----------+
  MariaDB [(wpdb)]> update wp_options set option_value='http://localhost' where option_name='siteurl';
  MariaDB [(wpdb)]> update wp_options set option_value='http://localhost' where option_name='home';
  ```
