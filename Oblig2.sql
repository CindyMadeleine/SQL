-- Oppgave 2-i
create view Selger as(
select personnr, salgsrolle
from salgspart
where salgsrolle = 'selger');


create view Megler as(
select personnr, salgsrolle
from salgspart
where salgsrolle = 'megler');

create view Kjoper as(
select personnr, salgsrolle
from salgspart
where salgsrolle = 'kjoper');

select p.personnr, b.adr, b.bolignr, p.navn
from selger s
natural join
kjoper k
natural join
megler m
natural join
person p
natural join 
boligsalg b
where personnr not null and salgsnr not null;



-- Oppgave 2-ii
CREATE RECURSIVE BoligEndring (boligtype, mnr, salgsnr)
select mnr, array[salgsnr], bs.boligtype
from boligsalg bs
union all
select mnr, salgsnr||bs.salgsnr, bs.boligtype
from BoligEndring be, boligsalg bs
where bs.mnr = be.mnr and bs.salgsnr not in (be.salgsnr) and bs.boligtype != be.boligtype

select array-length(salgsnr) as antallEndringer, mrn
from BoligEndring
group by mnr
having antallEndringer = max(antallEndringer);


-- Oppgave 2-iii
create view HarIkkeMegler as (
select mnr
from boligsalg b
where b.salgsnr NOT IN (
select s.salgsnr
from salgspart s
where s.salgsrolle = 'megler'));

select distinct mnr, knr, gnr, bnr, fnr, snr
from matrikkel m, harikkemegler h
where m.mnr = h.mnr;


