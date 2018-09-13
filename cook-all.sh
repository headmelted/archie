#!/bin/bash

echo "Entering kitchen"
cd /kitchen;

echo "Running all cook steps (get, build, package, test)";
. ./steps/cook.sh get build package test;
