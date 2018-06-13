-- set this option
SET SESSION group_concat_max_len = 100000
;
-- reset
DROP		TABLE IF EXISTS source_DataDictionary
;

CREATE	TABLE source_DataDictionary
		(
			NameOfDataElement VARCHAR(255)
               ,DevCategory VARCHAR(255)
               ,DeveloperFriendlyName VARCHAR(255)
               ,ApiDataType VARCHAR(255)
               ,VariableName VARCHAR(255)
               ,Value VARCHAR(255)
               ,Label VARCHAR(255)
               ,Source VARCHAR(255)
               ,Notes VARCHAR(1000)
		)
;

-- load from .csv
LOAD		DATA LOCAL INFILE 'C:/GitHub/college/Database/raw_files/dd.csv'
INTO		TABLE source_DataDictionary
COLUMNS	TERMINATED BY ','
ENCLOSED	BY '"'
LINES 	TERMINATED BY '\r\n'
IGNORE	1 LINES
;

UPDATE	source_DataDictionary
SET		NameOfDataElement = CASE LENGTH(TRIM(NameOfDataElement)) WHEN 0 THEN NULL ELSE NameOfDataElement END
		,DevCategory = CASE LENGTH(TRIM(DevCategory)) WHEN 0 THEN NULL ELSE DevCategory END
          ,DeveloperFriendlyName = CASE LENGTH(TRIM(DeveloperFriendlyName)) WHEN 0 THEN NULL ELSE DeveloperFriendlyName END
          ,ApiDataType = CASE LENGTH(TRIM(ApiDataType)) WHEN 0 THEN NULL ELSE ApiDataType END
          ,VariableName = CASE LENGTH(TRIM(VariableName)) WHEN 0 THEN NULL ELSE VariableName END
          ,Value = CASE LENGTH(TRIM(Value)) WHEN 0 THEN NULL ELSE Value END
          ,Label = CASE LENGTH(TRIM(Label)) WHEN 0 THEN NULL ELSE Label END
          ,Source = CASE LENGTH(TRIM(Source)) WHEN 0 THEN NULL ELSE Source END
          ,Notes = CASE LENGTH(TRIM(Notes)) WHEN 0 THEN NULL ELSE Notes END
;

-- add additional columns; data de-normalized
ALTER	TABLE source_DataDictionary
ADD		COLUMN DataDictionaryElementID INT FIRST
,ADD		COLUMN DataDictionaryElementValueID INT AUTO_INCREMENT NOT NULL PRIMARY KEY AFTER `DataDictionaryElementID`
;

UPDATE	source_DataDictionary
SET		DataDictionaryElementID = DataDictionaryElementValueID
WHERE	DeveloperFriendlyName IS NOT NULL
;

-- figure out the groupings
UPDATE	source_DataDictionary a
JOIN		(
			SELECT	a.DataDictionaryElementID
					,a.DataDictionaryElementValueID
					,MAX(a.PossibleElementValue) MaxElementValue
			FROM		(
						SELECT	a.DataDictionaryElementID
								,a.DataDictionaryElementValueID
								,b.DataDictionaryElementValueID PossibleElementValue
						FROM		source_DataDictionary a
								JOIN
								source_DataDictionary b
						WHERE	b.DataDictionaryElementID <= a.DataDictionaryElementValueID
					) a
			GROUP	BY a.DataDictionaryElementID
					,a.DataDictionaryElementValueID
		) b
		ON	a.DataDictionaryElementValueID = b.DataDictionaryElementValueID
SET		a.DataDictionaryElementID = b.MaxElementValue
;

DROP	TABLE IF EXISTS source_ScoreCard_fields
;

CREATE	TABLE source_ScoreCard_fields
		(
			FieldId INT PRIMARY KEY AUTO_INCREMENT
               ,FieldName VARCHAR(255) NOT NULL
          )
;

INSERT	source_ScoreCard_fields(FieldName)
VALUES	('UNITID')
		,('OPEID')
		,('OPEID6')
		,('INSTNM')
		,('CITY')
		,('STABBR')
		,('INSTURL')
		,('NPCURL')
		,('HCM2')
		,('PREDDEG')
		,('HIGHDEG')
		,('CONTROL')
		,('LOCALE')
		,('HBCU')
		,('PBI')
		,('ANNHI')
		,('TRIBAL')
		,('AANAPII')
		,('HSI')
		,('NANTI')
		,('MENONLY')
		,('WOMENONLY')
		,('RELAFFIL')
		,('SATVR25')
		,('SATVR75')
		,('SATMT25')
		,('SATMT75')
		,('SATWR25')
		,('SATWR75')
		,('SATVRMID')
		,('SATMTMID')
		,('SATWRMID')
		,('ACTCM25')
		,('ACTCM75')
		,('ACTEN25')
		,('ACTEN75')
		,('ACTMT25')
		,('ACTMT75')
		,('ACTWR25')
		,('ACTWR75')
		,('ACTCMMID')
		,('ACTENMID')
		,('ACTMTMID')
		,('ACTWRMID')
		,('SAT_AVG')
		,('SAT_AVG_ALL')
		,('PCIP01')
		,('PCIP03')
		,('PCIP04')
		,('PCIP05')
		,('PCIP09')
		,('PCIP10')
		,('PCIP11')
		,('PCIP12')
		,('PCIP13')
		,('PCIP14')
		,('PCIP15')
		,('PCIP16')
		,('PCIP19')
		,('PCIP22')
		,('PCIP23')
		,('PCIP24')
		,('PCIP25')
		,('PCIP26')
		,('PCIP27')
		,('PCIP29')
		,('PCIP30')
		,('PCIP31')
		,('PCIP38')
		,('PCIP39')
		,('PCIP40')
		,('PCIP41')
		,('PCIP42')
		,('PCIP43')
		,('PCIP44')
		,('PCIP45')
		,('PCIP46')
		,('PCIP47')
		,('PCIP48')
		,('PCIP49')
		,('PCIP50')
		,('PCIP51')
		,('PCIP52')
		,('PCIP54')
		,('DISTANCEONLY')
		,('UGDS')
		,('UGDS_WHITE')
		,('UGDS_BLACK')
		,('UGDS_HISP')
		,('UGDS_ASIAN')
		,('UGDS_AIAN')
		,('UGDS_NHPI')
		,('UGDS_2MOR')
		,('UGDS_NRA')
		,('UGDS_UNKN')
		,('PPTUG_EF')
		,('CURROPER')
		,('NPT4_PUB')
		,('NPT4_PRIV')
		,('NPT41_PUB')
		,('NPT42_PUB')
		,('NPT43_PUB')
		,('NPT44_PUB')
		,('NPT45_PUB')
		,('NPT41_PRIV')
		,('NPT42_PRIV')
		,('NPT43_PRIV')
		,('NPT44_PRIV')
		,('NPT45_PRIV')
		,('PCTPELL')
		,('RET_FT4_POOLED_SUPP')
		,('RET_FTL4_POOLED_SUPP')
		,('RET_PT4_POOLED_SUPP')
		,('RET_PTL4_POOLED_SUPP')
		,('PCTFLOAN')
		,('UG25ABV')
		,('MD_EARN_WNE_P10')
		,('GT_25K_P6')
		,('GRAD_DEBT_MDN_SUPP')
		,('GRAD_DEBT_MDN10YR_SUPP')
		,('RPY_3YR_RT_SUPP')
		,('C150_L4_POOLED_SUPP')
		,('C150_4_POOLED_SUPP')
;

DROP	TABLE IF EXISTS scoreCardFields
;

CREATE	TEMPORARY TABLE IF NOT EXISTS scoreCardFields(FieldName VARCHAR(255), DataType VARCHAR(255), IsIncluded BIT)
;

INSERT	scoreCardFields
SELECT	b.FieldName
		,CASE	
			WHEN ApiDataType = 'integer' AND NameOfDataElement LIKE 'Flag%' THEN 'BIT'
			WHEN	ApiDataType = 'integer' THEN 'INT'
			WHEN ApiDataType = 'float' THEN 'FLOAT(10,3)'
			ELSE 'VARCHAR(255)'
		END
          ,CASE
			WHEN DevCategory IN
			(
				'admissions'
				,'aid'
				,'cost'
				,'earnings'
				,'root'
				,'school'
				,'student'
			)
			THEN 1
			ELSE 0
		END IsIncluded
FROM		source_DataDictionary a
		JOIN
		source_ScoreCard_fields b
		ON	a.VariableName = b.FieldName
WHERE	DeveloperFriendlyName IS NOT NULL
;

DROP	TABLE IF EXISTS source_ScoreCard
;

SET	@createCommand =
	(
		SELECT	CONCAT
				(
					'CREATE	TABLE source_ScoreCard ('
					,GROUP_CONCAT(CONCAT(FieldName,SPACE(1),DataType) SEPARATOR ',')
					,')'
				) Statement
		FROM		scoreCardFields a
          WHERE	IsIncluded = 1
	)
;
PREPARE createCommand FROM @createCommand;
EXECUTE createCommand;

SET	@loadCommand = 
	(
		SELECT	CONCAT
				(
					"LOAD DATA LOCAL INFILE 'C:/GitHub/college/Database/raw_files/sc.csv' INTO TABLE source_ScoreCard COLUMNS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES ("
					,GROUP_CONCAT(FieldName SEPARATOR ',')
					,");"
				)
		FROM		(
					SELECT	CASE
								WHEN IsIncluded = 0 THEN '@dummy'
								ELSE FieldName
							END FieldName
					FROM		scoreCardFields a
				) a
	)
;

-- SELECT	@loadCommand;

LOAD DATA LOCAL INFILE 'C:/GitHub/college/Database/raw_files/sc.csv' INTO TABLE source_ScoreCard COLUMNS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (UNITID,OPEID,OPEID6,INSTNM,CITY,STABBR,INSTURL,NPCURL,HCM2,PREDDEG,HIGHDEG,CONTROL,LOCALE,HBCU,PBI,ANNHI,TRIBAL,AANAPII,HSI,NANTI,MENONLY,WOMENONLY,RELAFFIL,SATVR25,SATVR75,SATMT25,SATMT75,SATWR25,SATWR75,SATVRMID,SATMTMID,SATWRMID,ACTCM25,ACTCM75,ACTEN25,ACTEN75,ACTMT25,ACTMT75,ACTWR25,ACTWR75,ACTCMMID,ACTENMID,ACTMTMID,ACTWRMID,SAT_AVG,SAT_AVG_ALL,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,@dummy,DISTANCEONLY,UGDS,UGDS_WHITE,UGDS_BLACK,UGDS_HISP,UGDS_ASIAN,UGDS_AIAN,UGDS_NHPI,UGDS_2MOR,UGDS_NRA,UGDS_UNKN,PPTUG_EF,CURROPER,NPT4_PUB,NPT4_PRIV,NPT41_PUB,NPT42_PUB,NPT43_PUB,NPT44_PUB,NPT45_PUB,NPT41_PRIV,NPT42_PRIV,NPT43_PRIV,NPT44_PRIV,NPT45_PRIV,PCTPELL,PCTFLOAN,UG25ABV,MD_EARN_WNE_P10,GT_25K_P6,GRAD_DEBT_MDN_SUPP,GRAD_DEBT_MDN10YR_SUPP,@dummy,@dummy,@dummy,RET_FT4_POOLED_SUPP,RET_FTL4_POOLED_SUPP,RET_PT4_POOLED_SUPP,RET_PTL4_POOLED_SUPP)
;

select count(*) from source_DataDictionary; -- 2059
select count(*) from source_ScoreCard; -- 7593

select * from source_DataDictionary;
select * from source_ScoreCard;


/*
-- create dynamic sql based on business rules
SET	@createCommand = 
	(
		SELECT	CONCAT
				(
					'CREATE	TABLE source_ScoreCard ('
					,GROUP_CONCAT(Line SEPARATOR ',')
					,')'
				) Statement
		FROM		(
					SELECT	CONCAT
							(
								VariableName
								,SPACE(1)
								,CASE	
									WHEN ApiDataType = 'integer' AND NameOfDataElement LIKE 'Flag%' THEN 'BIT'
									WHEN	ApiDataType = 'interger' THEN 'INT'
									WHEN ApiDataType = 'float' THEN 'FLOAT(10,3)'
									ELSE 'VARCHAR(255)'
								END
							) Line
					select *
					FROM		source_DataDictionary
					WHERE	DataDictionaryElementID = DataDictionaryElementValueID
							AND DevCategory IN
							(
								'admissions'
								,'aid'
								,'cost'
								,'earnings'
								,'root'
								,'school'
								,'student'
							)
				) a
	)
;

-- prepare and execute the dynamic sql
PREPARE createCommand FROM @createCommand;
EXECUTE createCommand;

-- TODO: requires manual intervention

SET	@insertCommand =
	(
		SELECT	CONCAT
				(
					"LOAD DATA LOCAL INFILE 'C:/GitHub/college/Database/raw_files/dd.csv/sc.csv' INTO TABLE source_ScoreCard COLUMNS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES ("
					,GROUP_CONCAT(Field SEPARATOR ',')
					,");"
				)
		FROM		(
					SELECT	CASE
								WHEN b.Field IS NULL THEN '@dummy'
								ELSE b.Field
							END Field
					FROM		source_DataDictionary a
							LEFT JOIN
							(
								SELECT	COLUMN_NAME Field
								FROM		information_schema.COLUMNS  
								WHERE	TABLE_NAME = 'source_ScoreCard'
							) b
							ON	a.VariableName = b.Field
					WHERE	a.DataDictionaryElementID = a.DataDictionaryElementValueID
				) a
	)
;

PREPARE insertCommand FROM @insertCommand;
EXECUTE insertCommand;
*/
