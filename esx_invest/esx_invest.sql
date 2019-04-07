USE `essentialmode`;

CREATE TABLE invest (
  identifier VARCHAR(100) NOT NULL,
  amount INT(10) NOT NULL,
  job VARCHAR(100) NOT NULL,
  PRIMARY KEY (identifier)
);
