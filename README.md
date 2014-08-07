Procedural to Object-Oriented Modules
====================================

## Overview

A practical session on porting or writing modules to follow modern best practice object oriented PHP. Key points are:

* Iterative refactoring procedural code into modern object oriented PHP
* Making Drupal 7 modules Drupal 8 ready
* Common Drupal 8 Design Patterns (Observer pattern, Dependency Injection)
* Important changes in Drupal 8 that affect module development (eg. routes)
* Automate tools to assist in conversion of Drupal 7 modules to Drupal 8 (I am the author of Pharborist which is one such tool)
* Unit testing and mocking to drive higher quality code and faster development

## Setup

This presentation uses Markdown and Reveal.js. It requires the following package
installed to compile.
```
npm install -g reveal-md
```

To test that it is working run the following command:

```
reveal-md demo
```

## Compile

To compile and test the slides, run the following command:

```
reveal-md slides.md
```
