-- FUNCTION: Création de la fonction - sig.papph_commune_insee_superf()

-- DROP FUNCTION sig.papph_commune_insee_superf();

CREATE FUNCTION sig.papph_commune_insee_superf()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF 
AS $BODY$
BEGIN 
	NEW.commune := nom_com FROM sig.papph_communes_secteur WHERE sde.st_intersects(NEW.shape, shape);
	NEW.code_insee := insee_com FROM sig.papph_communes_secteur WHERE sde.st_intersects(NEW.shape, shape);
	NEW.subdi := subdivision FROM sig.papph_communes_secteur WHERE sde.st_intersects(NEW.shape, shape);
	NEW.superf_espace := st_area(NEW.shape);	
	NEW.id_parcelle := string_agg(DISTINCT CONCAT(section,parcelle), ', ') FROM sig.cadastre_parcelle WHERE sde.st_intersects(NEW.shape, shape);
	RETURN NEW; 
	END

$BODY$;

ALTER FUNCTION sig.papph_commune_insee_superf()
    OWNER TO sig;
	

-- Trigger: Ajout du trigger au layer : papph_commune_insee_superf

-- DROP TRIGGER papph_commune_insee_superf ON sig.espacesamenages_cahm;

CREATE TRIGGER papph_commune_insee_superf
    BEFORE INSERT OR UPDATE 
    ON sig.espacesamenages_cahm
    FOR EACH ROW
    EXECUTE PROCEDURE sig.papph_commune_insee_superf();