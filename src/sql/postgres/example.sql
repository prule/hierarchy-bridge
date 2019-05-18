-- create sample database
create database hierarchy_bridge_example;

-- table to hold our example hierarchy - each row points to its parent
create table hierarchies
(
    hierarchy_id text,
    hierarchy_name text,
    parent_hierarchy_id text
);

-- hierarchy data
INSERT INTO hierarchies values ('1' , 'A', NULL);
INSERT INTO hierarchies values ('2' , 'B', '1');
INSERT INTO hierarchies values ('3' , 'C', '1');
INSERT INTO hierarchies values ('4' , 'D', '2');

select * from hierarchies;

-- bridge table
create table hierarchies_bridge
(
    parent_id text,
    child_id text,
    levels_removed text
);

-- populate bridge table
WITH recursive Descendant AS (
    SELECT hierarchy_id AS parent_id, hierarchy_id As child_id, 0 AS levels_removed
                              FROM hierarchies
                              UNION ALL
                              SELECT D.parent_id, H.hierarchy_id AS ChildId, D.levels_removed + 1 AS levels_removed
                              FROM Descendant D
                                       JOIN hierarchies H ON D.child_id = H.parent_hierarchy_id
    )
insert
into hierarchies_bridge
(SELECT * FROM Descendant)
;

-- view the bridge table
select * from hierarchies_bridge;

-- all under A
select child_id from hierarchies_bridge where parent_id='1';
-- all under B
select child_id from hierarchies_bridge where parent_id='2';
-- all under C
select child_id from hierarchies_bridge where parent_id='3';
-- all from D and below
select child_id from hierarchies_bridge where parent_id='4';
