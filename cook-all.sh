#!/bin/bash

echo "Running all cook steps (get, build, package, test)";
. ./steps/cook.sh get build package test;
