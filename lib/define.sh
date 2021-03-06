#!/bin/bash
# Copyright 2017 dimattiami, prussian <genunrest@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ -z "$4" ]; then
    echo ":mn $3 This command requires a search query"
    exit 0
fi

DICTIONARY="http://www.dictionary.com/browse/$(URI_ENCODE "$4")"

echo "$DICTIONARY" |
    wget -O- -i- --quiet | 
    hxnormalize -x 2>/dev/null | 
    hxselect -i "div.def-set" 2>/dev/null |  
    lynx -stdin -dump 2>/dev/null |
    xargs 2>/dev/null |
    sed 's/[0-9]\./\n&/g' |
    head -n 4 |
    sed '/^$/d' |
    sed '/file:\/\//d' |
while read -r definition; do
    (( ${#definition} > 400 )) && 
        definition="${definition:0:400}..."
    echo -e ":m $1 "$'\002'"${4}\002 :: $definition"
done

echo ":mn $3 See More: $DICTIONARY"
