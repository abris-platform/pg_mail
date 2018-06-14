Postgres 10 compatible extension
based on
https://github.com/captbrando/pgMail/
without quotation of mailto and mailfrom
adapted for the SMTP-servers requesting  CRLF.CRLF for QUIT

for installation 

apt-get install postgresql-pltcl-10
CREATE LANGUAGE pltclu;
change <<yourdatabaseaddress>> and <<yourmailserver>> in pg_mail.sql
run pg_mail.sql

for using

select pg_mail('<mailfrom@mail.ru>','<mailto@mail.ru>',
 'Subject goes here','Plaintext message body here.', 'HTML message body here.');
# pg_mail
