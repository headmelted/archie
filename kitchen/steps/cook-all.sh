#!/bin/bash

echo "Running all cook steps (get, build, package, test)";
. ./cook.sh get build package test;
