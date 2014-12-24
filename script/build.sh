#!/bin/bash

. script/functions

smitty pushd src
smitty docker build --rm -t duoauthproxy .
smitty popd
