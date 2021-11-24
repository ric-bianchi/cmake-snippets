#
# Copyright (C) 2019 by Riccardo Maria BIANCHI - ric@riccardomariabianchi.com
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
#
# ---
# 
# GENERATING GRAPHVIZ GRAPHS AUTOMATICALLY AT CONFIGURATION TIME
#
# This snippet generates the graphviz .dot file and graph images at configuration time,
# without the need of calling `make targetname` after configuration, at build step.
# 
# At first it generates the .dot file by recursively calling cmake. 
# Then it calls 'dot' over the generated '.dot' file and generates the images.
# A Note: it is not really suitable for projects with many '-D' options, because those are not passed
# along the recursive call automatically, they have to be passed manually in the COMMAND.
# 
# ---
# Inspired by: https://stackoverflow.com/a/43153487/320369
# 

option(RECURSIVE_GENERATE "Recursive call to cmake to generate the graphviz graphs" OFF)

if(NOT RECURSIVE_GENERATE)
    message(STATUS "Recursive generate started")
    execute_process(COMMAND ${CMAKE_COMMAND} "--graphviz=depgraph.dot" .
        -G "${CMAKE_GENERATOR}"
        -T "${CMAKE_GENERATOR_TOOLSET}"
        -A "${CMAKE_GENERATOR_PLATFORM}" 
        -DRECURSIVE_GENERATE:BOOL=ON 
        ${CMAKE_SOURCE_DIR})
    message(STATUS "Recursive generate done")

    # your post-generate steps here
    
    execute_process(
		    COMMAND dot -T png depgraph.dot -o depgraph.png
		    COMMAND dot -T pdf depgraph.dot -o depgraph.pdf
		    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
        )

    # exit without doing anything else, since it already happened
    return()
endif()

# The rest of the script is only processed by the executed cmake, as it 
# sees RECURSIVE_GENERATE true

# all your normal configuration, targets, etc go here

