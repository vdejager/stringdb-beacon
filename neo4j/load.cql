// The prefix "sdb:" is added to make the identifiers curies.

CREATE CONSTRAINT ON (protein:Protein) ASSERT protein.stringId IS UNIQUE;

CREATE CONSTRAINT ON (species:Species) ASSERT species.taxonId IS UNIQUE;

// ---- Load Actions ---- //

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///import/9606.protein.actions.v10.5.txt" AS row FIELDTERMINATOR '\t'
WITH DISTINCT row.item_id_a as id_a, row.item_id_b as id_b
MERGE (a:Protein {stringId: "sdb:" + id_a})
MERGE (b:Protein {stringId: "sdb:" + id_b});

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///import/9606.protein.actions.v10.5.txt" AS row FIELDTERMINATOR '\t'
MATCH (a:Protein {stringId: "sdb:" + row.item_id_a})
MATCH (b:Protein {stringId: "sdb:" + row.item_id_b})
MERGE (a)-[relation:ACTION {mode: row.mode}]-(b)
ON CREATE SET
  relation.action = row.action,
  relation.is_directional = row.is_directional,
  relation.a_is_acting = row.a_is_acting,
  relation.score = row.score;

// ---- Load Aliases ---- //

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///import/9606.protein.aliases.v10.5.txt" AS row FIELDTERMINATOR '\t'
MATCH (p:Protein {stringId: "sdb:" + row.string_protein_id})
SET p.alias = row.alias, p.source = row.source;

// ---- Load Species ---- //

USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM "file:///import/species.v10.5.txt" AS row FIELDTERMINATOR '\t'
MERGE (s:Species {taxonId: "sdb:" + row.taxon_id})
ON CREATE SET
  s.STRING_name_compact = row.STRING_name_compact,
  s.official_name_NCBI = row.official_name_NCBI,
  s.STRING_type = row.STRING_type;

MATCH (p: Protein) WITH p as p, HEAD(SPLIT(p.stringId, '.')) as taxonCurie
MATCH (s: Species {taxonId: taxonCurie})
MERGE (p)-[:TAXON]->(s);
