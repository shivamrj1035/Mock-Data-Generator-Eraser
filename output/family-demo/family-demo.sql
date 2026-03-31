CREATE TABLE IF NOT EXISTS "users" (
  "id" UUID NOT NULL,
  "email" TEXT UNIQUE,
  "phone" TEXT,
  "password_hash" TEXT,
  "status" TEXT,
  "created_at" TIMESTAMP,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "kutumb" (
  "id" UUID NOT NULL,
  "name" TEXT,
  "origin_place" TEXT,
  "description" TEXT,
  "created_at" TIMESTAMP,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "roles" (
  "id" UUID NOT NULL,
  "name" TEXT,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "members" (
  "id" UUID NOT NULL,
  "first_name" TEXT,
  "last_name" TEXT,
  "gender" TEXT,
  "dob" DATE,
  "is_alive" BOOLEAN,
  "created_by_user_id" UUID,
  "is_claimed" BOOLEAN,
  "primary_kutumb_id" UUID,
  "created_at" TIMESTAMP,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "categories" (
  "id" UUID NOT NULL,
  "kutumb_id" UUID,
  "name" TEXT,
  "type" TEXT,
  "parent_id" UUID,
  "level" INTEGER,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "member_category_map" (
  "id" UUID NOT NULL,
  "member_id" UUID,
  "category_id" UUID,
  "role_id" UUID,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "relationships" (
  "id" UUID NOT NULL,
  "member_id" UUID,
  "related_member_id" UUID,
  "relation_type" TEXT,
  "is_bi_directional" BOOLEAN,
  "created_by" UUID,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "marriages" (
  "id" UUID NOT NULL,
  "husband_member_id" UUID,
  "wife_member_id" UUID,
  "marriage_date" DATE,
  "wife_kutumb_id" UUID,
  "husband_kutumb_id" UUID,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "member_identity_keys" (
  "id" UUID NOT NULL,
  "member_id" UUID,
  "key_type" TEXT,
  "key_value" TEXT,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "user_member_map" (
  "id" UUID NOT NULL,
  "user_id" UUID,
  "member_id" UUID,
  "relation_type" TEXT,
  "is_primary" BOOLEAN,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "member_roles" (
  "id" UUID NOT NULL,
  "member_id" UUID,
  "role_id" UUID,
  "scope_type" TEXT,
  "scope_id" UUID,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "visibility_rules" (
  "id" UUID NOT NULL,
  "owner_member_id" UUID,
  "viewer_member_id" UUID,
  "max_depth" INTEGER,
  "allow_descendants" BOOLEAN,
  "allow_ancestors" BOOLEAN,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "member_field_permissions" (
  "id" UUID NOT NULL,
  "member_id" UUID,
  "field_name" TEXT,
  "visibility" TEXT,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "member_access_overrides" (
  "id" UUID NOT NULL,
  "member_id" UUID,
  "viewer_member_id" UUID,
  "access_type" TEXT,
  PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "member_profiles" (
  "member_id" UUID NOT NULL,
  "highest_education" TEXT,
  "profession" TEXT,
  "company" TEXT,
  "native_place" TEXT,
  "current_city" TEXT,
  "marital_status" TEXT,
  PRIMARY KEY ("member_id")
);

ALTER TABLE "members" ADD CONSTRAINT "fk_members_created_by_user_id" FOREIGN KEY ("created_by_user_id") REFERENCES "users" ("id");
ALTER TABLE "members" ADD CONSTRAINT "fk_members_primary_kutumb_id" FOREIGN KEY ("primary_kutumb_id") REFERENCES "kutumb" ("id");
ALTER TABLE "categories" ADD CONSTRAINT "fk_categories_kutumb_id" FOREIGN KEY ("kutumb_id") REFERENCES "kutumb" ("id");
ALTER TABLE "categories" ADD CONSTRAINT "fk_categories_parent_id" FOREIGN KEY ("parent_id") REFERENCES "categories" ("id");
ALTER TABLE "member_category_map" ADD CONSTRAINT "fk_member_category_map_member_id" FOREIGN KEY ("member_id") REFERENCES "members" ("id");
ALTER TABLE "member_category_map" ADD CONSTRAINT "fk_member_category_map_category_id" FOREIGN KEY ("category_id") REFERENCES "categories" ("id");
ALTER TABLE "relationships" ADD CONSTRAINT "fk_relationships_member_id" FOREIGN KEY ("member_id") REFERENCES "members" ("id");
ALTER TABLE "relationships" ADD CONSTRAINT "fk_relationships_related_member_id" FOREIGN KEY ("related_member_id") REFERENCES "members" ("id");
ALTER TABLE "marriages" ADD CONSTRAINT "fk_marriages_husband_member_id" FOREIGN KEY ("husband_member_id") REFERENCES "members" ("id");
ALTER TABLE "marriages" ADD CONSTRAINT "fk_marriages_wife_member_id" FOREIGN KEY ("wife_member_id") REFERENCES "members" ("id");
ALTER TABLE "member_identity_keys" ADD CONSTRAINT "fk_member_identity_keys_member_id" FOREIGN KEY ("member_id") REFERENCES "members" ("id");
ALTER TABLE "user_member_map" ADD CONSTRAINT "fk_user_member_map_user_id" FOREIGN KEY ("user_id") REFERENCES "users" ("id");
ALTER TABLE "user_member_map" ADD CONSTRAINT "fk_user_member_map_member_id" FOREIGN KEY ("member_id") REFERENCES "members" ("id");
ALTER TABLE "member_roles" ADD CONSTRAINT "fk_member_roles_member_id" FOREIGN KEY ("member_id") REFERENCES "members" ("id");
ALTER TABLE "member_roles" ADD CONSTRAINT "fk_member_roles_role_id" FOREIGN KEY ("role_id") REFERENCES "roles" ("id");
ALTER TABLE "visibility_rules" ADD CONSTRAINT "fk_visibility_rules_owner_member_id" FOREIGN KEY ("owner_member_id") REFERENCES "members" ("id");
ALTER TABLE "visibility_rules" ADD CONSTRAINT "fk_visibility_rules_viewer_member_id" FOREIGN KEY ("viewer_member_id") REFERENCES "members" ("id");
ALTER TABLE "member_field_permissions" ADD CONSTRAINT "fk_member_field_permissions_member_id" FOREIGN KEY ("member_id") REFERENCES "members" ("id");
ALTER TABLE "member_access_overrides" ADD CONSTRAINT "fk_member_access_overrides_member_id" FOREIGN KEY ("member_id") REFERENCES "members" ("id");
ALTER TABLE "member_access_overrides" ADD CONSTRAINT "fk_member_access_overrides_viewer_member_id" FOREIGN KEY ("viewer_member_id") REFERENCES "members" ("id");
ALTER TABLE "member_profiles" ADD CONSTRAINT "fk_member_profiles_member_id" FOREIGN KEY ("member_id") REFERENCES "members" ("id");

INSERT INTO "users" ("id", "email", "phone", "password_hash", "status", "created_at")
VALUES
('18e8ba11-0569-4e52-b1f0-0d3abb96efe2', 'Adonis.Beahan42@example.com', '+18185035189', 'kKmVHjIo9HncKGAXgf8VCQLlWI1CPnWazfrte8uDYxhmUBz34eSY5KKstTpr', 'INACTIVE', '2026-01-20 23:17:34'),
('373c12d3-eb51-4c0b-a789-4d02e937d86f', 'Kenny.Schinner89@example.com', '+16852849190', 'xuswFxIPFL1iSfaf5dnqpYRYFVGn8SpYLq3NLlt5o8uh0mXYFhimYiXcUlyk', 'INACTIVE', '2022-08-09 19:22:11'),
('5b9aa780-b8a6-4faa-9853-fc3f085e7f91', 'Kyleigh94@example.com', '+16026204515', 'opebIutLFZedUL6KPW0Bd005bthjrQwiBvC8wdHpe7p4BGvoa6bEhMNWojIp', 'PENDING', '2025-12-07 13:07:25'),
('df6ae2bb-2055-4721-ae7a-d5e864708af1', 'Rita_Gerhold81@example.com', '+14355083393', 'Sn0g0cQBAXiv3U3srCJUNgpA4vRfWvMhS77lSQwJguLTOAMoacpOKaLFbUfi', 'INACTIVE', '2023-09-23 13:01:40'),
('11a3196d-e024-4599-bc91-3dcdaa62c59c', 'Diane_Bruen73@example.org', '+18438145517', '7UJoHOCYu3vp5HQqHKaMw77haqnhZFB50F2WsqgwZk9LNwO4eKjqkyISpB6q', 'PENDING', '2021-06-20 00:57:39'),
('7e54cf80-b6d3-41ad-a005-f81ee39bef88', 'Eva_Turcotte82@example.net', '+19012797051', 'MSAlwwRzlIxeHBrsMY84hF6wdj3wu7Pjw93u96nFlfmYEthYpidwq3QkiYi7', 'INACTIVE', '2021-09-26 05:35:01'),
('17ce52f5-4780-4eca-b760-cf6b68e440c7', 'Blanche9@example.org', '+17406192354', 'K8ia0knBut0CJGPeFlVS1q6mpx2ZsD1kMBAqxETIW5nb0yP8dhAyNYuVwBAE', 'PENDING', '2024-01-28 06:28:22'),
('1c56c4f8-1318-491c-907b-35c0b39f2522', 'Arch.Dietrich@example.net', '+16413527346', 'UPzhbtnpPtnZ7ggDt63UUsPscmWp9srikdW15F0Msxfe5HUfbR58XHFshaIl', 'ACTIVE', '2024-05-04 22:13:04'),
('3b391ce5-872d-4e5b-b50d-be2466522450', 'Baby_McGlynn61@example.com', '+12483606315', 'Lk7jX1jbouS83MUsJBwFo3iCHtHz0k8sl6VY0z8fLClAfIPHtNeQR5sAF1Xq', 'INACTIVE', '2023-06-22 21:39:41'),
('4f3b28f7-a59a-48da-874d-ada68d0d5a9e', 'Morgan.Blick@example.net', '+15723591577', 'G3c4E45eMCZQSlu3quAq2rg5SPxOZzLNprAzKdLdYfCvTmakVDA8cdtumhjR', 'INACTIVE', '2021-08-25 12:08:04'),
('4e2df0ad-fa6d-4cc5-9718-1ca3dd58df28', 'Robyn80@example.net', '+15219607141', 'ykfQknazEXz1b8OqAECbloHdOLJeCdjd5Xy4fUSLV4stOKtyA7wcHnq4NFeY', 'ACTIVE', '2021-12-20 06:07:50'),
('de08e36e-63ed-4231-b991-fb2f9911e365', 'Chanel69@example.com', '+13808724893', 'VZYHRBgPRhgcg8kA1dyAfNTTU8VlvqSWn27VWhKPWLVj2lxo7gyte3yD52mE', 'PENDING', '2023-07-03 00:41:59')
ON CONFLICT ("id") DO UPDATE SET "email" = EXCLUDED."email", "phone" = EXCLUDED."phone", "password_hash" = EXCLUDED."password_hash", "status" = EXCLUDED."status", "created_at" = EXCLUDED."created_at";

INSERT INTO "kutumb" ("id", "name", "origin_place", "description", "created_at")
VALUES
('eaa72987-090f-45a8-bc7a-ee6d401617ab', 'South Valley vicinity Family', 'New Presleyville', 'Cattus callide cicuta.', '2023-04-21 08:16:05'),
('d2294d42-4cc4-457c-862b-2ddd2e5b6f92', 'New Mitchellcester futon Family', 'Kent', 'Thesaurus virtus amor talus cunabula.', '2026-03-06 15:47:12'),
('7876a9cd-6a72-48d3-95e0-95d6ade2675a', 'Johnsonview labourer Family', 'Fort Arleneburgh', 'Tamen degenero vester tamen benigne valetudo claustrum.', '2023-10-10 06:39:48'),
('eb0ef08f-78d5-48f8-ba7b-cb73bfc91c68', 'Mosciskiland onset Family', 'Brendenfort', 'Thalassinus currus vivo desolo conscendo tepesco amicitia ulciscor.', '2025-06-08 06:11:22'),
('9c2e5aec-8c42-400b-8166-a26dee08084c', 'Fort Sibylside optimal Family', 'Runolfssonfurt', 'Defluo celer sol.', '2022-12-27 14:54:42'),
('1df9fe6c-18ee-4533-8677-eeaeb3bb89f6', 'Goodyear scholarship Family', 'Hegmannboro', 'Arceo avarus subito adhuc sono adamo statim.', '2024-02-15 17:30:53'),
('83e44ce0-9898-4ae7-bf18-4a5b9ba0bd70', 'Claudineport lamp Family', 'Highland', 'Thesis quo torrens absorbeo solutio charisma.', '2024-12-30 21:03:37'),
('a3181693-fe93-43d9-b9fc-d5d01b429c3a', 'Gainesville sport Family', 'Fort Kelvinside', 'Dolor conatus minus cornu tondeo concido.', '2025-05-28 10:12:58'),
('525c3637-4f34-4d35-9ace-4bbe0ce23b09', 'New Raoulside scrap Family', 'Port Eliasbury', 'Barba laudantium vulgus perspiciatis cito.', '2023-06-02 15:10:00'),
('0a1724fc-c446-4bd0-a29b-1cdea2f104e2', 'Beerhaven millet Family', 'Lake Nellie', 'Adfero ventosus cruentus super.', '2024-09-16 02:12:24'),
('fe64edbe-7271-4009-8126-5822ac1a42bf', 'Framitown hose Family', 'North Olga', 'Tibi velut cohors laboriosam sit creta tubineus sum ager alii.', '2022-02-25 16:58:01'),
('68976d81-56f1-4592-baf4-bf753cf4a4f1', 'Fort Wilma blowgun Family', 'Lake Enrique', 'Conduco vetus subiungo.', '2025-07-01 07:55:28')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name", "origin_place" = EXCLUDED."origin_place", "description" = EXCLUDED."description", "created_at" = EXCLUDED."created_at";

INSERT INTO "roles" ("id", "name")
VALUES
('029129ac-a188-4f1b-b0c3-1e6a0cd13769', 'SUPER_ADMIN'),
('349e80b2-a97a-4464-854d-b4521efcab45', 'SUPER_ADMIN'),
('ffd94b71-cdf8-4885-85fd-42f47d5779d4', 'SUPER_ADMIN'),
('43647f91-bbc1-4fd4-b870-b7186c73abf5', 'CATEGORY_ADMIN'),
('e34dc907-d39b-4f03-9e94-6d1da2702e1e', 'MEMBER'),
('ebf8a872-9eab-431d-b409-8f777699fa83', 'CATEGORY_ADMIN'),
('b7750996-b3e0-4b41-850f-85ff6b6da229', 'SUPER_ADMIN'),
('b820fb91-51bd-434f-9c06-4b1f1890d80c', 'CATEGORY_ADMIN'),
('1f0bdd38-4542-461a-84e7-110bd4a60f9b', 'KUTUMB_ADMIN'),
('d1248226-a344-4c2e-9be6-58a645773063', 'CATEGORY_ADMIN'),
('d1a8f940-88bc-4c4f-a730-2e548ddf185e', 'KUTUMB_ADMIN'),
('26905c83-0ac2-49a7-8f51-177f417b5ac5', 'MEMBER')
ON CONFLICT ("id") DO UPDATE SET "name" = EXCLUDED."name";

INSERT INTO "members" ("id", "first_name", "last_name", "gender", "dob", "is_alive", "created_by_user_id", "is_claimed", "primary_kutumb_id", "created_at")
VALUES
('80376ee1-296c-401e-a5e4-78c131d4a2e9', 'Corine', 'Cartwright', 'male', '1946-10-31', FALSE, '18e8ba11-0569-4e52-b1f0-0d3abb96efe2', TRUE, 'fe64edbe-7271-4009-8126-5822ac1a42bf', '2022-06-12 04:12:48'),
('0d31a44f-052f-4438-950b-8a7b44fcafd3', 'Ronald', 'Graham', 'female', '1976-01-30', TRUE, 'df6ae2bb-2055-4721-ae7a-d5e864708af1', FALSE, 'eaa72987-090f-45a8-bc7a-ee6d401617ab', '2021-08-26 05:41:40'),
('8616f6e1-c09a-4e62-a7f7-36228547b20b', 'Gerhard', 'Price', 'male', '1982-06-24', TRUE, '373c12d3-eb51-4c0b-a789-4d02e937d86f', FALSE, '9c2e5aec-8c42-400b-8166-a26dee08084c', '2026-02-04 17:12:12'),
('43c20df4-4834-48f4-8f06-9d50a7866ce7', 'Alexander', 'Kunze', 'male', '1999-06-13', TRUE, '373c12d3-eb51-4c0b-a789-4d02e937d86f', FALSE, '0a1724fc-c446-4bd0-a29b-1cdea2f104e2', '2021-12-08 04:27:51'),
('74cbe1c0-ed5b-4742-a901-1577a4f593c1', 'Madaline', 'Mitchell', 'male', '1943-08-04', TRUE, '17ce52f5-4780-4eca-b760-cf6b68e440c7', TRUE, '7876a9cd-6a72-48d3-95e0-95d6ade2675a', '2023-08-19 02:00:50'),
('e5763011-91f9-4f03-8271-e399c0ef9ffc', 'Bernard', 'Kessler', 'female', '1945-04-25', FALSE, '18e8ba11-0569-4e52-b1f0-0d3abb96efe2', FALSE, 'eaa72987-090f-45a8-bc7a-ee6d401617ab', '2024-09-15 07:06:36'),
('5b2db341-ff65-44c7-9dec-e60c17b251bd', 'Nolan', 'Beier', 'male', '1945-06-05', TRUE, '11a3196d-e024-4599-bc91-3dcdaa62c59c', FALSE, 'eaa72987-090f-45a8-bc7a-ee6d401617ab', '2023-07-25 16:14:02'),
('511be31e-70c8-4b6e-a13c-3bb2403798c9', 'Santos', 'Conn', 'female', '1943-03-08', TRUE, 'df6ae2bb-2055-4721-ae7a-d5e864708af1', FALSE, '1df9fe6c-18ee-4533-8677-eeaeb3bb89f6', '2022-07-31 15:05:44'),
('dcdd0988-3293-409f-8d2b-c012df3b4238', 'Saul', 'Graham', 'male', '1944-04-08', TRUE, '18e8ba11-0569-4e52-b1f0-0d3abb96efe2', FALSE, '0a1724fc-c446-4bd0-a29b-1cdea2f104e2', '2023-12-25 10:56:59'),
('c3776677-b602-4473-a65d-59c646996b4b', 'Viola', 'Howell', 'male', '1953-02-14', TRUE, '7e54cf80-b6d3-41ad-a005-f81ee39bef88', FALSE, '68976d81-56f1-4592-baf4-bf753cf4a4f1', '2022-09-29 17:24:49'),
('0eece324-6772-46d6-8300-0bb6c2b5fe90', 'Sterling', 'Hammes', 'male', '1969-01-25', TRUE, '7e54cf80-b6d3-41ad-a005-f81ee39bef88', TRUE, '0a1724fc-c446-4bd0-a29b-1cdea2f104e2', '2022-02-14 07:17:29'),
('eb89a16e-0469-454f-bfea-2f8931328ee8', 'Jerad', 'Brown', 'female', '1936-09-03', FALSE, '17ce52f5-4780-4eca-b760-cf6b68e440c7', FALSE, '7876a9cd-6a72-48d3-95e0-95d6ade2675a', '2025-08-02 07:15:46')
ON CONFLICT ("id") DO UPDATE SET "first_name" = EXCLUDED."first_name", "last_name" = EXCLUDED."last_name", "gender" = EXCLUDED."gender", "dob" = EXCLUDED."dob", "is_alive" = EXCLUDED."is_alive", "created_by_user_id" = EXCLUDED."created_by_user_id", "is_claimed" = EXCLUDED."is_claimed", "primary_kutumb_id" = EXCLUDED."primary_kutumb_id", "created_at" = EXCLUDED."created_at";

INSERT INTO "categories" ("id", "kutumb_id", "name", "type", "parent_id", "level")
VALUES
('d7d071f4-068a-48b2-9191-b410acee888c', '68976d81-56f1-4592-baf4-bf753cf4a4f1', 'Central Branch', 'FAMILY_BRANCH', NULL, 1),
('ad0e0cc4-568a-43be-ad37-16f885c9bb9f', '7876a9cd-6a72-48d3-95e0-95d6ade2675a', 'Central Branch', 'CITY', NULL, 2),
('f72606ac-847e-4c18-9182-a1b35577cbea', '0a1724fc-c446-4bd0-a29b-1cdea2f104e2', 'North Zone', 'SUBGROUP', 'd7d071f4-068a-48b2-9191-b410acee888c', 2),
('ec4707db-1edc-4eb5-87c1-f19eb570ce2c', 'a3181693-fe93-43d9-b9fc-d5d01b429c3a', 'Central Branch', 'FAMILY_BRANCH', 'f72606ac-847e-4c18-9182-a1b35577cbea', 1),
('b603ca08-1185-4329-9846-67361bbacca0', 'fe64edbe-7271-4009-8126-5822ac1a42bf', 'Surat Circle', 'SUBGROUP', 'ad0e0cc4-568a-43be-ad37-16f885c9bb9f', 2),
('b9c05373-4d28-490e-b139-ca168747ac60', 'eaa72987-090f-45a8-bc7a-ee6d401617ab', 'Ahmedabad Group', 'FAMILY_BRANCH', 'f72606ac-847e-4c18-9182-a1b35577cbea', 1),
('e0dfbadc-3367-4a55-896e-2662e9cc5b5a', 'a3181693-fe93-43d9-b9fc-d5d01b429c3a', 'Central Branch', 'FAMILY_BRANCH', NULL, 4),
('bd796d37-1fff-465e-9872-e317b4026efd', '83e44ce0-9898-4ae7-bf18-4a5b9ba0bd70', 'Surat Circle', 'CITY', 'b9c05373-4d28-490e-b139-ca168747ac60', 3),
('b9ff4ca4-9d51-4e01-8d0b-088749d90b4e', 'eb0ef08f-78d5-48f8-ba7b-cb73bfc91c68', 'Ahmedabad Group', 'CITY', 'b9c05373-4d28-490e-b139-ca168747ac60', 3),
('86d3d765-2d63-4fc7-b55f-b1bd470f090f', '7876a9cd-6a72-48d3-95e0-95d6ade2675a', 'North Zone', 'SUBGROUP', NULL, 2),
('dfbf7d9c-b7a6-455c-bec0-6dce79eb8f8d', '9c2e5aec-8c42-400b-8166-a26dee08084c', 'North Zone', 'FAMILY_BRANCH', 'ec4707db-1edc-4eb5-87c1-f19eb570ce2c', 1),
('774591ca-63fe-434f-8d03-c7d627b339b7', '525c3637-4f34-4d35-9ace-4bbe0ce23b09', 'Ahmedabad Group', 'CITY', 'b9ff4ca4-9d51-4e01-8d0b-088749d90b4e', 2)
ON CONFLICT ("id") DO UPDATE SET "kutumb_id" = EXCLUDED."kutumb_id", "name" = EXCLUDED."name", "type" = EXCLUDED."type", "parent_id" = EXCLUDED."parent_id", "level" = EXCLUDED."level";

INSERT INTO "member_category_map" ("id", "member_id", "category_id", "role_id")
VALUES
('10cbc109-961f-41df-8273-db042c58fae6', 'eb89a16e-0469-454f-bfea-2f8931328ee8', 'e0dfbadc-3367-4a55-896e-2662e9cc5b5a', 'f2db2458-27f3-4f1a-aaff-3cec4f514d92'),
('23682eaf-9604-4aab-bf2c-5861d8e4495e', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 'ec4707db-1edc-4eb5-87c1-f19eb570ce2c', '92512d03-e9d1-43cf-9057-7d89c9c2ce12'),
('4d233f41-ce9d-44e4-bc6a-eaaa344a6de2', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'b9c05373-4d28-490e-b139-ca168747ac60', '97589d09-4942-4e30-8a4d-92e4110a40b1'),
('27187e46-0ea6-4db5-a26b-e854d81ef8f4', 'c3776677-b602-4473-a65d-59c646996b4b', 'b9ff4ca4-9d51-4e01-8d0b-088749d90b4e', '9463bc32-0f91-4c87-8af4-8b748ee55d10'),
('3760fe83-9167-441c-9ee0-5664581bb985', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 'bd796d37-1fff-465e-9872-e317b4026efd', '988750b4-a947-4839-9e31-cac972af5b24'),
('173fa090-06d7-4e4f-b814-42abf29f2bc6', 'e5763011-91f9-4f03-8271-e399c0ef9ffc', 'f72606ac-847e-4c18-9182-a1b35577cbea', '7e51da4b-b963-4f99-8f91-b88e72af86b8'),
('6eab2fdf-ac1d-46ee-b2ee-e0b696cd2d21', '0d31a44f-052f-4438-950b-8a7b44fcafd3', 'b9ff4ca4-9d51-4e01-8d0b-088749d90b4e', '61d09faa-d10a-4bac-8a8d-8cd6c7b90cbd'),
('1606784d-8b60-43b1-842d-38adea129fc8', '0d31a44f-052f-4438-950b-8a7b44fcafd3', 'b9c05373-4d28-490e-b139-ca168747ac60', 'c97c49d1-e1aa-4482-97c8-bec52d26b41d'),
('bfd9ce50-52e5-4cc7-8910-773499a60b72', '80376ee1-296c-401e-a5e4-78c131d4a2e9', '774591ca-63fe-434f-8d03-c7d627b339b7', 'decbeeed-9926-4f81-9c02-fe228b59e9d1'),
('dc9d689e-8f79-4883-9ef5-ec942d72b91f', 'eb89a16e-0469-454f-bfea-2f8931328ee8', '774591ca-63fe-434f-8d03-c7d627b339b7', '71815004-4910-4449-8411-cff4aad62932'),
('52745aab-bafa-4421-8b17-009cfb39f689', 'dcdd0988-3293-409f-8d2b-c012df3b4238', 'ec4707db-1edc-4eb5-87c1-f19eb570ce2c', '28129b1f-8bd1-46b0-9ad2-823fafda240d'),
('14de92a7-b2c2-4123-97b1-3bb4bb0cc88d', 'eb89a16e-0469-454f-bfea-2f8931328ee8', 'ec4707db-1edc-4eb5-87c1-f19eb570ce2c', '36d17403-7ca8-4b74-903c-616c974dbc82')
ON CONFLICT ("id") DO UPDATE SET "member_id" = EXCLUDED."member_id", "category_id" = EXCLUDED."category_id", "role_id" = EXCLUDED."role_id";

INSERT INTO "relationships" ("id", "member_id", "related_member_id", "relation_type", "is_bi_directional", "created_by")
VALUES
('d336afa9-8bbb-4287-bd78-d2f12c18c834', 'c3776677-b602-4473-a65d-59c646996b4b', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'child', FALSE, 'fb40c004-e078-4f08-96f6-456a7c360c07'),
('ddfa5a72-7b01-41c5-aab1-9be07eeaf2ce', '5b2db341-ff65-44c7-9dec-e60c17b251bd', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'sibling', TRUE, '8c93dc42-c389-4907-8e16-8f1c0f5c8e5b'),
('b40dc8bc-7d29-4009-9599-3713eaf9ed65', '43c20df4-4834-48f4-8f06-9d50a7866ce7', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'father', TRUE, '4647fb1c-759e-42cf-aac6-99ff95fec8d1'),
('b8ac3a0d-3d47-437f-b505-b3c1da2d9eff', '0d31a44f-052f-4438-950b-8a7b44fcafd3', '43c20df4-4834-48f4-8f06-9d50a7866ce7', 'spouse', TRUE, '0ac97b08-d161-4b10-a1c0-ccfd3119a5c3'),
('0b80ffe0-fe26-4fa8-a704-acda5f3bacc9', '8616f6e1-c09a-4e62-a7f7-36228547b20b', '43c20df4-4834-48f4-8f06-9d50a7866ce7', 'sibling', FALSE, '4f3ec203-cf97-4ed2-8eaf-04a8d82b4ada'),
('01073018-80a8-422b-9c04-a7ece34fbc3d', '80376ee1-296c-401e-a5e4-78c131d4a2e9', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'sibling', FALSE, 'e94f5ae7-a05b-4a90-bc2e-48e1e720cb9f'),
('36802f3a-24df-4ea0-ad7b-936cbe04027c', '5b2db341-ff65-44c7-9dec-e60c17b251bd', '511be31e-70c8-4b6e-a13c-3bb2403798c9', 'sibling', FALSE, 'e824c600-f6fa-4b75-acb7-016a06859919'),
('8d57f5ff-05c8-4f42-9c3f-ecb3a670c57b', '43c20df4-4834-48f4-8f06-9d50a7866ce7', 'c3776677-b602-4473-a65d-59c646996b4b', 'sibling', FALSE, '62ba6a92-f9ed-4d37-a24b-8d52c10b48f7'),
('854197e8-eafe-4a5c-abf1-c192e8ef18df', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'dcdd0988-3293-409f-8d2b-c012df3b4238', 'child', FALSE, '1725bc88-2c5f-4920-b854-9c4b2b200672'),
('8ddd9708-d0a0-4e2b-aef3-6b9592b61ab1', '0d31a44f-052f-4438-950b-8a7b44fcafd3', '8616f6e1-c09a-4e62-a7f7-36228547b20b', 'child', FALSE, 'fa384528-7e73-499a-99e6-e80b9e254986'),
('aa5d2cc8-cbc9-4337-b203-9572438490cf', '80376ee1-296c-401e-a5e4-78c131d4a2e9', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'father', TRUE, 'cf2089b3-8eec-45e0-ba0e-2c2092cb3c25'),
('32c1d4fd-3c06-405b-abb8-07d82de25dcd', '8616f6e1-c09a-4e62-a7f7-36228547b20b', '0d31a44f-052f-4438-950b-8a7b44fcafd3', 'mother', TRUE, '495f28b1-43e5-4b6d-bfe5-da76616d7041')
ON CONFLICT ("id") DO UPDATE SET "member_id" = EXCLUDED."member_id", "related_member_id" = EXCLUDED."related_member_id", "relation_type" = EXCLUDED."relation_type", "is_bi_directional" = EXCLUDED."is_bi_directional", "created_by" = EXCLUDED."created_by";

INSERT INTO "marriages" ("id", "husband_member_id", "wife_member_id", "marriage_date", "wife_kutumb_id", "husband_kutumb_id")
VALUES
('db3da70e-4c8a-43ff-b6a4-b20aac2a4b89', '74cbe1c0-ed5b-4742-a901-1577a4f593c1', 'e5763011-91f9-4f03-8271-e399c0ef9ffc', '2017-01-29', 'e3b445eb-8311-48db-89e4-954753222779', 'a38ee234-da37-4d9c-935c-5c6db6333350'),
('001e873f-7362-40ce-ac38-de6e984f7771', 'dcdd0988-3293-409f-8d2b-c012df3b4238', '0d31a44f-052f-4438-950b-8a7b44fcafd3', '2016-07-30', '943e6d70-a94b-4d09-bb68-d4cedb137cc3', 'fb0619ed-6b37-464b-9219-c47242c4f733'),
('70eb9145-721c-4448-8ccb-7d20b4a39fef', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'eb89a16e-0469-454f-bfea-2f8931328ee8', '2023-12-31', 'c9a84b92-501e-465c-8515-577c5679638d', '6afa142b-b171-4b89-abdb-cf9ae4f231fc'),
('007f0aef-4f2d-42f6-a0a6-23101144af2f', 'dcdd0988-3293-409f-8d2b-c012df3b4238', '511be31e-70c8-4b6e-a13c-3bb2403798c9', '2020-01-31', '24c371ed-6c75-47eb-9484-e050db5f7d4b', 'd8639810-6b36-4746-89ad-e799f20ac70c'),
('b90139c9-b7fa-4a0d-948e-8a9b872acce5', '80376ee1-296c-401e-a5e4-78c131d4a2e9', '511be31e-70c8-4b6e-a13c-3bb2403798c9', '2023-07-17', '40b2e0cf-538b-40b0-8c21-9bbb4895c44b', 'a6facc2f-ae5f-4526-8f4b-652a41e08d33'),
('91802e36-cd73-4ddf-be50-c2ec6f4f4073', 'dcdd0988-3293-409f-8d2b-c012df3b4238', 'eb89a16e-0469-454f-bfea-2f8931328ee8', '2015-08-31', '1fea4342-c70a-4056-a36a-979ce40397b0', 'e3494265-1779-4276-b21d-f4e8a8b2c783'),
('fa33d52a-689c-415c-a3f7-785628660b5a', 'dcdd0988-3293-409f-8d2b-c012df3b4238', 'e5763011-91f9-4f03-8271-e399c0ef9ffc', '2016-09-15', 'ee1b3a61-1c00-4c51-b4dd-009f6ad4e573', '9eb04f6e-a089-4b48-879d-59e68353e0f1'),
('398a901b-67de-475c-907e-1e5cc565dfd0', '0eece324-6772-46d6-8300-0bb6c2b5fe90', '0d31a44f-052f-4438-950b-8a7b44fcafd3', '2018-09-30', 'ba2ab1af-e82b-4431-9c91-fb4c19803e82', 'de2702af-44b4-46e7-a855-d64f2dda1c69'),
('12c05a90-8203-4c40-b0de-d17ab489d889', '0eece324-6772-46d6-8300-0bb6c2b5fe90', '0d31a44f-052f-4438-950b-8a7b44fcafd3', '2018-10-29', 'e7504e27-b13e-4492-bc90-2d8733471b2f', '9758931d-36d1-4447-be49-4e537a06ae96'),
('395e139b-0bda-46b7-b54c-e25d9d964dec', 'dcdd0988-3293-409f-8d2b-c012df3b4238', '0d31a44f-052f-4438-950b-8a7b44fcafd3', '2018-05-14', '433c8cca-ccf2-4529-ad9a-0ce8462cfae8', '9a2bb988-c891-4e62-864c-cf493cba236e'),
('eb2f3352-1cf0-43d8-b177-57c9a0025881', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'e5763011-91f9-4f03-8271-e399c0ef9ffc', '2013-08-12', '400633dc-867f-47bc-88e1-23e9c194bf31', 'cc5e14a3-9ab7-4ef4-9895-2a54ad37bd50'),
('f8462007-2ea4-4ff6-9dd0-6c168558c852', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 'e5763011-91f9-4f03-8271-e399c0ef9ffc', '2014-10-02', '0821a058-d6ff-41b3-ba67-19011bfbf14b', 'c3d9f1c1-6378-4efa-9b50-e67609aa5160')
ON CONFLICT ("id") DO UPDATE SET "husband_member_id" = EXCLUDED."husband_member_id", "wife_member_id" = EXCLUDED."wife_member_id", "marriage_date" = EXCLUDED."marriage_date", "wife_kutumb_id" = EXCLUDED."wife_kutumb_id", "husband_kutumb_id" = EXCLUDED."husband_kutumb_id";

INSERT INTO "member_identity_keys" ("id", "member_id", "key_type", "key_value")
VALUES
('650f0369-9845-4211-b2d1-c244ea099533', '43c20df4-4834-48f4-8f06-9d50a7866ce7', 'EMAIL', 'brS3yqdIkWHwru8KmJuJ'),
('f23d6fa9-cb92-43d6-91ca-15a94a5aa037', '511be31e-70c8-4b6e-a13c-3bb2403798c9', 'NAME_DOB_HASH', 'ZplkW07niQH0bkcBUSfR'),
('53d5189b-bb2f-41df-b31c-80dba303f96b', '43c20df4-4834-48f4-8f06-9d50a7866ce7', 'PHONE', 'xDtvDJUaVmtZkiTEud1z'),
('346194c3-2840-43c1-99a6-77870e762372', '8616f6e1-c09a-4e62-a7f7-36228547b20b', 'PHONE', 'gfBrMNzRZfj3FO3ftlUv'),
('08f7d404-9391-4c90-8488-776129c60a33', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'EMAIL', 'Ik7BCs8hEnsJQM2h7SSP'),
('6f5c8302-ed45-4f9a-90e1-b592ff64c3b1', '43c20df4-4834-48f4-8f06-9d50a7866ce7', 'PHONE', '0F61czSw1YzOJUucmdsU'),
('dfed92c5-0799-432f-99dc-3c36f09cb0a1', '43c20df4-4834-48f4-8f06-9d50a7866ce7', 'EMAIL', 'EQrVdRgeohPQuy3xnhVj'),
('364ca0ca-b8cf-468a-9a6a-98c0585d9651', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 'EMAIL', 'WhivY9M3knvh9jx2Hk63'),
('64baeafa-c46d-40cd-8aeb-e0428cfaa614', '0d31a44f-052f-4438-950b-8a7b44fcafd3', 'EMAIL', 'irHKvoFThvgs7TPZwllS'),
('05b3fe54-e4ce-4aad-b3dd-0842087684b3', '0d31a44f-052f-4438-950b-8a7b44fcafd3', 'PHONE', 'n1jLZvxNzHvMsg86lAN4'),
('27dcfe4c-a6b4-45ef-8f6c-119b28f1ea8a', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 'NAME_DOB_HASH', 'tHX7jpuMz9c9wXOi7zjT'),
('05008645-6363-4313-9d38-466dcf21fced', 'eb89a16e-0469-454f-bfea-2f8931328ee8', 'PHONE', '2alqT0vXBTu1BcQZ1LRt')
ON CONFLICT ("id") DO UPDATE SET "member_id" = EXCLUDED."member_id", "key_type" = EXCLUDED."key_type", "key_value" = EXCLUDED."key_value";

INSERT INTO "user_member_map" ("id", "user_id", "member_id", "relation_type", "is_primary")
VALUES
('46d48a1a-9894-47a2-abfd-53d6a58a7e32', '11a3196d-e024-4599-bc91-3dcdaa62c59c', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'SPOUSE', FALSE),
('83be4472-d2b5-4c79-b47e-bb641c89cd7c', '4f3b28f7-a59a-48da-874d-ada68d0d5a9e', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 'SPOUSE', TRUE),
('0e173317-05d5-4909-ba42-6d3a5442e37f', '5b9aa780-b8a6-4faa-9853-fc3f085e7f91', '511be31e-70c8-4b6e-a13c-3bb2403798c9', 'SPOUSE', TRUE),
('3370b820-24aa-465c-b9e6-3ece3418b852', '4e2df0ad-fa6d-4cc5-9718-1ca3dd58df28', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'SPOUSE', FALSE),
('3622f7b9-0d58-4040-9bbb-9ce82ea750ce', '5b9aa780-b8a6-4faa-9853-fc3f085e7f91', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'SELF', TRUE),
('abeb83e4-22b8-46d8-9b26-aaf8885f6c74', 'df6ae2bb-2055-4721-ae7a-d5e864708af1', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'CHILD', TRUE),
('32ee929d-3ee8-46af-8bc5-b7c7254040a8', 'df6ae2bb-2055-4721-ae7a-d5e864708af1', 'dcdd0988-3293-409f-8d2b-c012df3b4238', 'SELF', FALSE),
('b9fa0371-402f-4783-957f-8d6474828f86', '7e54cf80-b6d3-41ad-a005-f81ee39bef88', '0d31a44f-052f-4438-950b-8a7b44fcafd3', 'SPOUSE', TRUE),
('f0dfaebd-55d5-4aa4-8c59-68e249539552', '11a3196d-e024-4599-bc91-3dcdaa62c59c', '511be31e-70c8-4b6e-a13c-3bb2403798c9', 'CHILD', TRUE),
('5c5503fd-18af-4e4c-b73b-7633178855bd', '1c56c4f8-1318-491c-907b-35c0b39f2522', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'SELF', TRUE),
('41599a83-099a-4fa4-95f6-37d9e9ba0374', '18e8ba11-0569-4e52-b1f0-0d3abb96efe2', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'PARENT', TRUE),
('5aa3ca4c-0c59-4dc1-adc5-30ad00a87fd7', '5b9aa780-b8a6-4faa-9853-fc3f085e7f91', '511be31e-70c8-4b6e-a13c-3bb2403798c9', 'PARENT', FALSE)
ON CONFLICT ("id") DO UPDATE SET "user_id" = EXCLUDED."user_id", "member_id" = EXCLUDED."member_id", "relation_type" = EXCLUDED."relation_type", "is_primary" = EXCLUDED."is_primary";

INSERT INTO "member_roles" ("id", "member_id", "role_id", "scope_type", "scope_id")
VALUES
('b7ecbe45-0087-4173-9c54-c89b21c7fd49', '74cbe1c0-ed5b-4742-a901-1577a4f593c1', '349e80b2-a97a-4464-854d-b4521efcab45', 'KUTUMB', '5dfb31b2-638d-4d56-a25d-9a0e97256acd'),
('a120725f-b127-4d11-b57f-2bc4a0fc9985', '8616f6e1-c09a-4e62-a7f7-36228547b20b', '26905c83-0ac2-49a7-8f51-177f417b5ac5', 'KUTUMB', 'b99d1d37-0798-4f74-ad6d-0cd2d1ed1953'),
('31363bfc-2906-4d84-99d9-84a408a3bce0', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 'd1248226-a344-4c2e-9be6-58a645773063', 'KUTUMB', '83f662bc-a6eb-453c-94d4-b3f56bc792d7'),
('200c446d-dd67-4213-b324-446558cd498f', 'e5763011-91f9-4f03-8271-e399c0ef9ffc', '43647f91-bbc1-4fd4-b870-b7186c73abf5', 'GLOBAL', '2e888fc5-3445-4927-bfbb-807641fe3353'),
('f7e2311e-5ff0-406c-9407-2132ab03ad30', '0d31a44f-052f-4438-950b-8a7b44fcafd3', 'ebf8a872-9eab-431d-b409-8f777699fa83', 'GLOBAL', '353aaf0e-06a4-48bb-ba61-3edb1f25734a'),
('9e8e72d4-55a5-4e47-93b8-46a9f1b74e5a', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'd1a8f940-88bc-4c4f-a730-2e548ddf185e', 'GLOBAL', '25c0d849-6d83-4c61-b999-2f62dee1dfed'),
('9d0b118b-026b-4571-9ae9-e90c1de493cd', 'eb89a16e-0469-454f-bfea-2f8931328ee8', 'ffd94b71-cdf8-4885-85fd-42f47d5779d4', 'CATEGORY', 'db55dfcf-71ae-4caa-b866-788f9f202a7d'),
('d1716ee3-6d87-4ea7-ae8b-df6601a19ca8', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'd1248226-a344-4c2e-9be6-58a645773063', 'CATEGORY', 'fb2828db-e7ba-49a8-8b6d-a14181a63a0a'),
('676fc6a6-be27-4a64-9f79-1b666d65f7f2', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'ffd94b71-cdf8-4885-85fd-42f47d5779d4', 'GLOBAL', '3c95d7e0-fa0a-4e61-8a3c-154deb1cf2b3'),
('f49712fd-f413-497c-bbfb-340834ae3c02', '0d31a44f-052f-4438-950b-8a7b44fcafd3', '1f0bdd38-4542-461a-84e7-110bd4a60f9b', 'GLOBAL', '40b34909-b385-41a4-be90-cbc5fbab2ffc'),
('01c289d5-c972-4984-b673-397f9fcc3b06', '8616f6e1-c09a-4e62-a7f7-36228547b20b', '26905c83-0ac2-49a7-8f51-177f417b5ac5', 'CATEGORY', 'e28e6b71-c4ed-497c-95f8-82c1313b4071'),
('acb4e3ba-4565-4cdc-b803-5d17cc9e0241', '0d31a44f-052f-4438-950b-8a7b44fcafd3', '349e80b2-a97a-4464-854d-b4521efcab45', 'CATEGORY', 'd7cc865b-c288-44f9-8a3e-1c1a1bdf773c')
ON CONFLICT ("id") DO UPDATE SET "member_id" = EXCLUDED."member_id", "role_id" = EXCLUDED."role_id", "scope_type" = EXCLUDED."scope_type", "scope_id" = EXCLUDED."scope_id";

INSERT INTO "visibility_rules" ("id", "owner_member_id", "viewer_member_id", "max_depth", "allow_descendants", "allow_ancestors")
VALUES
('090de2ed-c454-4c11-97a8-0b19942ea648', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 'e5763011-91f9-4f03-8271-e399c0ef9ffc', 2, FALSE, FALSE),
('3f2d8756-e7e6-450c-8029-db82f4255e1b', '74cbe1c0-ed5b-4742-a901-1577a4f593c1', '511be31e-70c8-4b6e-a13c-3bb2403798c9', 1, TRUE, FALSE),
('30334a53-a6d9-4c41-aacf-fe057cd59980', '5b2db341-ff65-44c7-9dec-e60c17b251bd', '74cbe1c0-ed5b-4742-a901-1577a4f593c1', 1, FALSE, TRUE),
('eb15c065-25bd-4d76-a2e6-e06e02eac88f', 'c3776677-b602-4473-a65d-59c646996b4b', 'dcdd0988-3293-409f-8d2b-c012df3b4238', 2, FALSE, TRUE),
('6507c2a9-f761-4794-90ec-1b5c10e29f73', 'c3776677-b602-4473-a65d-59c646996b4b', 'eb89a16e-0469-454f-bfea-2f8931328ee8', 4, FALSE, FALSE),
('802435fb-a438-4975-894d-5dc580a3b9da', '8616f6e1-c09a-4e62-a7f7-36228547b20b', 'eb89a16e-0469-454f-bfea-2f8931328ee8', 4, TRUE, TRUE),
('20b0889e-7d65-402a-a82e-20cb806c63fe', '511be31e-70c8-4b6e-a13c-3bb2403798c9', 'c3776677-b602-4473-a65d-59c646996b4b', 4, TRUE, TRUE),
('7c38360b-f198-4af0-96bd-e6e59fe91df2', 'dcdd0988-3293-409f-8d2b-c012df3b4238', '0d31a44f-052f-4438-950b-8a7b44fcafd3', 4, TRUE, FALSE),
('dbde5fdd-3b59-4dfa-b5d4-a3b9641d8179', 'eb89a16e-0469-454f-bfea-2f8931328ee8', '511be31e-70c8-4b6e-a13c-3bb2403798c9', 1, TRUE, TRUE),
('276c544a-55b0-4281-8864-452417f04285', '5b2db341-ff65-44c7-9dec-e60c17b251bd', '74cbe1c0-ed5b-4742-a901-1577a4f593c1', 4, TRUE, TRUE),
('217daa5c-d458-42ab-bb10-a41db7651e77', '8616f6e1-c09a-4e62-a7f7-36228547b20b', '43c20df4-4834-48f4-8f06-9d50a7866ce7', 3, TRUE, FALSE),
('66bf2229-3476-42d2-9da2-2f03c23e5f50', '43c20df4-4834-48f4-8f06-9d50a7866ce7', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 4, TRUE, FALSE)
ON CONFLICT ("id") DO UPDATE SET "owner_member_id" = EXCLUDED."owner_member_id", "viewer_member_id" = EXCLUDED."viewer_member_id", "max_depth" = EXCLUDED."max_depth", "allow_descendants" = EXCLUDED."allow_descendants", "allow_ancestors" = EXCLUDED."allow_ancestors";

INSERT INTO "member_field_permissions" ("id", "member_id", "field_name", "visibility")
VALUES
('c72d76cd-5054-4d31-97dd-de8b70143eec', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'phone', 'FAMILY'),
('aa3b210c-ee9d-4932-a42c-13a583c079e5', 'e5763011-91f9-4f03-8271-e399c0ef9ffc', 'dob', 'CUSTOM'),
('70c8ed1a-d113-4435-a682-ce42d0a58810', '0d31a44f-052f-4438-950b-8a7b44fcafd3', 'phone', 'PUBLIC'),
('41d9ea35-beb7-4201-8147-bb6f7f13f099', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 'phone', 'FAMILY'),
('6f6bb09a-a56b-4942-8634-da009e5fbbb6', '511be31e-70c8-4b6e-a13c-3bb2403798c9', 'dob', 'FAMILY'),
('79c7c8d5-f45a-4006-b3ef-1c9db220e075', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'phone', 'PUBLIC'),
('f1358a87-9632-42e4-b485-94fbd8dfbac9', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'dob', 'CUSTOM'),
('d0f998b3-7808-4d79-bd3f-6f4fe06db3d5', 'c3776677-b602-4473-a65d-59c646996b4b', 'dob', 'CUSTOM'),
('8b0a3bc6-97f6-42ba-b766-e427268053df', '74cbe1c0-ed5b-4742-a901-1577a4f593c1', 'phone', 'PUBLIC'),
('9cbebfd8-b057-4f1a-aedf-30e1337366f3', '5b2db341-ff65-44c7-9dec-e60c17b251bd', 'education', 'CUSTOM'),
('27f34f20-7fee-4226-b66c-ce12532d47cb', '43c20df4-4834-48f4-8f06-9d50a7866ce7', 'education', 'PUBLIC'),
('b2dc57ff-dd89-4dc2-9d1b-18f038738a76', '43c20df4-4834-48f4-8f06-9d50a7866ce7', 'dob', 'FAMILY')
ON CONFLICT ("id") DO UPDATE SET "member_id" = EXCLUDED."member_id", "field_name" = EXCLUDED."field_name", "visibility" = EXCLUDED."visibility";

INSERT INTO "member_access_overrides" ("id", "member_id", "viewer_member_id", "access_type")
VALUES
('6b5f1945-c889-41c3-8d75-9a15c31c8faf', '0eece324-6772-46d6-8300-0bb6c2b5fe90', '43c20df4-4834-48f4-8f06-9d50a7866ce7', 'VIEW'),
('b3740e7d-af44-4ca3-8bf8-ce8a2411200e', 'c3776677-b602-4473-a65d-59c646996b4b', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'VIEW'),
('60153601-88ed-4192-ad8e-bcf5d749cc91', '8616f6e1-c09a-4e62-a7f7-36228547b20b', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'EDIT'),
('c37fdca9-2fce-4b1a-813c-a2995ebdaf55', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 'c3776677-b602-4473-a65d-59c646996b4b', 'EDIT'),
('6aa5e571-51e0-4061-aac9-e4faa69ab596', 'c3776677-b602-4473-a65d-59c646996b4b', '511be31e-70c8-4b6e-a13c-3bb2403798c9', 'EDIT'),
('7a28e76e-ec3e-4da4-8cf8-cf3b6881256d', '8616f6e1-c09a-4e62-a7f7-36228547b20b', '511be31e-70c8-4b6e-a13c-3bb2403798c9', 'VIEW'),
('21cdd1e3-262a-4298-bdc5-7cc15e357401', '0d31a44f-052f-4438-950b-8a7b44fcafd3', '0d31a44f-052f-4438-950b-8a7b44fcafd3', 'VIEW'),
('d4bccc11-d10d-4940-b7c4-1a415bcde227', 'eb89a16e-0469-454f-bfea-2f8931328ee8', 'eb89a16e-0469-454f-bfea-2f8931328ee8', 'EDIT'),
('4847e480-ed2c-479b-833e-d7471ee88c50', 'eb89a16e-0469-454f-bfea-2f8931328ee8', 'dcdd0988-3293-409f-8d2b-c012df3b4238', 'EDIT'),
('27246a16-3cd2-4d8a-b79c-3cc06e440ca3', '74cbe1c0-ed5b-4742-a901-1577a4f593c1', '80376ee1-296c-401e-a5e4-78c131d4a2e9', 'EDIT'),
('4f5f6248-b009-4958-801c-68ba8b1df3c8', '0d31a44f-052f-4438-950b-8a7b44fcafd3', 'e5763011-91f9-4f03-8271-e399c0ef9ffc', 'VIEW'),
('616151df-9ab3-43ee-bd4b-e8fee3013e07', '0eece324-6772-46d6-8300-0bb6c2b5fe90', '0eece324-6772-46d6-8300-0bb6c2b5fe90', 'EDIT')
ON CONFLICT ("id") DO UPDATE SET "member_id" = EXCLUDED."member_id", "viewer_member_id" = EXCLUDED."viewer_member_id", "access_type" = EXCLUDED."access_type";

INSERT INTO "member_profiles" ("member_id", "highest_education", "profession", "company", "native_place", "current_city", "marital_status")
VALUES
('80376ee1-296c-401e-a5e4-78c131d4a2e9', 'Master''s Degree', 'Customer Division Agent', 'Muller and Sons', 'Douglasmouth', 'Feilchester', 'PENDING'),
('0d31a44f-052f-4438-950b-8a7b44fcafd3', 'Bachelor''s Degree', 'Investor Interactions Coordinator', 'Schowalter Inc', 'Jacobsonton', 'Akron', 'ACTIVE'),
('8616f6e1-c09a-4e62-a7f7-36228547b20b', 'Master''s Degree', 'Direct Solutions Director', 'Altenwerth, Stoltenberg and Kulas', 'Fort Elenatown', 'Lake Darrylport', 'ACTIVE'),
('43c20df4-4834-48f4-8f06-9d50a7866ce7', 'PhD', 'Lead Operations Technician', 'Hilll-Berge LLC', 'Carmel', 'Duluth', 'INACTIVE'),
('74cbe1c0-ed5b-4742-a901-1577a4f593c1', 'Bachelor''s Degree', 'Central Security Facilitator', 'Mitchell LLC', 'Camden', 'Passaic', 'INACTIVE'),
('e5763011-91f9-4f03-8271-e399c0ef9ffc', 'Bachelor''s Degree', 'Legacy Integration Engineer', 'Stamm Inc', 'Virginia Beach', 'Cape Coral', 'PENDING'),
('5b2db341-ff65-44c7-9dec-e60c17b251bd', 'Master''s Degree', 'Customer Functionality Liaison', 'Donnelly - White', 'North Charleston', 'Zulaufchester', 'ACTIVE'),
('511be31e-70c8-4b6e-a13c-3bb2403798c9', 'High School', 'Future Mobility Consultant', 'Rice - Carter', 'West Marlonstead', 'Dougboro', 'INACTIVE'),
('dcdd0988-3293-409f-8d2b-c012df3b4238', 'High School', 'Product Creative Designer', 'Kozey, Feeney and Labadie', 'North Rosemary', 'Shelleyport', 'INACTIVE'),
('c3776677-b602-4473-a65d-59c646996b4b', 'Master''s Degree', 'Global Creative Facilitator', 'Brown, Kirlin and Wunsch', 'West Andrew', 'Quitzonstad', 'ACTIVE'),
('0eece324-6772-46d6-8300-0bb6c2b5fe90', 'Master''s Degree', 'Lead Interactions Strategist', 'Pacocha LLC', 'Gwendolynstead', 'Dalefort', 'PENDING'),
('eb89a16e-0469-454f-bfea-2f8931328ee8', 'Bachelor''s Degree', 'Investor Identity Developer', 'Stroman - Senger', 'Lillaside', 'South Donnie', 'ACTIVE')
ON CONFLICT ("member_id") DO UPDATE SET "highest_education" = EXCLUDED."highest_education", "profession" = EXCLUDED."profession", "company" = EXCLUDED."company", "native_place" = EXCLUDED."native_place", "current_city" = EXCLUDED."current_city", "marital_status" = EXCLUDED."marital_status";