CREATE TABLE IF NOT EXISTS Employees (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	department VARCHAR(40) NOT NULL,
	chief INTEGER REFERENCES Employees(id)
);
