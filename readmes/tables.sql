CREATE TABLE logs(
                     log_id SERIAL PRIMARY KEY,
                     user_name varchar(50),
                     description text,
                     log_ts timestamp with time zone NOT NULL DEFAULT now()
);
CREATE INDEX idx_logs_log_ts ON logs USING btree(log_ts);

--

CREATE TABLE logs2(
                      log_id2 INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                      user_name2 varchar(50),
                      description2 text,
                      log_ts2 timestamp with time zone NOT NULL DEFAULT now()
);

--

CREATE TABLE logs_2011 (PRIMARY KEY (log_id)) INHERITS (logs);
ALTER TABLE logs_2011 ADD CONSTRAINT chk_y2011 CHECK (log_ts >= '2011-1-1'::timestamptz AND log_ts < '2012-1-1'::timestamptz);
INSERT INTO public.logs (user_name, description, log_ts) VALUES('PADRE', 'PADRE', '2011-09-09');

---
