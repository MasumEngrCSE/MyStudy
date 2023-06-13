CREATE TABLE t_history (
        id                 serial,
        tstamp             timestamp       DEFAULT now(),
        schemaname         text,
        tabname            text,
        operation          text,
        who                text            DEFAULT current_user,
        new_val            json,
        old_val            json,
        TrnsBY				Int
        
);



---------------Create Generic trigger

CREATE FUNCTION change_trigger() RETURNS trigger AS $$
        BEGIN
                IF      TG_OP = 'INSERT'
                THEN
                        INSERT INTO t_history (tabname, schemaname, operation, new_val)
                                VALUES (TG_RELNAME, TG_TABLE_SCHEMA, TG_OP, row_to_json(NEW));
                        RETURN NEW;
                ELSIF   TG_OP = 'UPDATE'
                THEN
                        INSERT INTO t_history (tabname, schemaname, operation, new_val, old_val)
                                VALUES (TG_RELNAME, TG_TABLE_SCHEMA, TG_OP,
                                        row_to_json(NEW), row_to_json(OLD));
                        RETURN NEW;
                ELSIF   TG_OP = 'DELETE'
                THEN
                        INSERT INTO t_history (tabname, schemaname, operation, old_val)
                                VALUES (TG_RELNAME, TG_TABLE_SCHEMA, TG_OP, row_to_json(OLD));
                        RETURN OLD;
                END IF;
        END;
$$ LANGUAGE 'plpgsql' SECURITY DEFINER;

----------------Apply Trigger to Table

CREATE TRIGGER t BEFORE INSERT OR UPDATE OR DELETE ON "RIS_ORDERDTL"
        FOR EACH ROW EXECUTE PROCEDURE change_trigger();