# Picorules

## Introduction
Picorule syntax is designed to author clinical logic targetting an EADV information model. The script is ultimately compiled in to SQL allowing method 4 dynamic SQL execution. The light weight compiler it self is written in PL/SQL. The syntax abstracts subquery factoring and allows the author to use variables and boolean logic in a simplified manner. 

## Structure

A set of instructions is compartmentalized into a rule block. There are just two type of statements in picorules

- Functional statements : Used to retrieve data from EADV data schema. A statement always returns one row per patient, and are essentially SQL aggregate or windowing functions.
- Conditional statements : Work on variables (hyper-atributes )
