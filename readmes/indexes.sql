
SELECT am.amname AS index_method,
opf.opfname AS opfamily_name,
amop.amopopr::regoperator AS opfamily_operator
FROM pg_am am, pg_opfamily opf, pg_amop amop
WHERE opf.opfmethod = am.oid AND
amop.amopfamily = opf.oid
ORDER BY index_method, opfamily_name, opfamily_operator;




--Esempio, se ho un indice su un campo text e uso una query con LIKE (~~), l'indice non viene usato... perché nellc classe degli
-- operatori sui campi di test (text_ops) il like non è contemplato.
-- Se voglio una cosa specifica lo devo dichiarare.
CREATE INDEX orders_2_order_id ON public.orders USING btree (order_id text_pattern_ops);
-- Da dbeaver, sull'indice si vede quale è la sua Operator Class.
-- Se non si specifica niente usa quella di default.

-- FUNCTIONAL INDEXES
create index idx on public.orders using btree (upper(via) text_pattern_ops);