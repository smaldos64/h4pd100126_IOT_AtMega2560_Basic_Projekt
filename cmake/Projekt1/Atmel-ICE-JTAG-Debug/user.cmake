# Tilføj assembler-listningsfil (-Wa,-adhlns) til alle C- og ASM-filer
# add_compile_options("-Wa,-adhlns=${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.lst")

# Tving assembler-listningsfil ud under kompilering
#add_compile_options($<$<COMPILE_LANGUAGE:C>:-Wa,-adhlns=${CMAKE_CURRENT_BINARY_DIR}/main.lst>)

# Tving XC8/GCC til at generere assembly listing-filer
#add_compile_options(-Wa,-ahlms=${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.lst)

# Automatisk generering af assembler-listefil (.lst) efter build ved brug af avr-objdump
# add_custom_command(
#     TARGET ${PROJECT_NAME} POST_BUILD
#     COMMAND avr-objdump -h -S $<TARGET_FILE:${PROJECT_NAME}> > "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.lst"
#     COMMENT "Genererer assembler listefil (.lst)..."
# )


# Dynamisk post-build: Genererer .lst-fil via CMake's indbyggede execute_process
# Implementationen herunder virker fuldt ud på Windows !!!
# get_property(_targets DIRECTORY PROPERTY BUILDSYSTEM_TARGETS)
# foreach(_target IN LISTS _targets)
#     get_target_property(_target_type ${_target} TYPE)
#     if(_target_type STREQUAL "EXECUTABLE")
        
#         # Vi lader CMake køre processen direkte som et post-build trin uden midlertidige filer
#         add_custom_command(
#             TARGET ${_target} POST_BUILD
#             COMMAND "${CMAKE_COMMAND}" -E echo "Genererer assembler listefil..."
#             COMMAND "c:/Program Files/Microchip/xc8/v4.00/bin/avr-objdump.exe" -h -S "$<TARGET_FILE:${_target}>" > "$<TARGET_FILE_DIR:${_target}>/${_target}.lst"
#             COMMENT "Opretter .lst fil ved siden af .elf-filen"
#             VERBATIM
#         )
#     endif()
# endforeach()

# Dynamisk post-build: Cross-platform generering af .lst-fil i samme mappe som .elf-filen
get_property(_targets DIRECTORY PROPERTY BUILDSYSTEM_TARGETS)
foreach(_target IN LISTS _targets)
    get_target_property(_target_type ${_target} TYPE)
    if(_target_type STREQUAL "EXECUTABLE")
        
        # Vælg automatisk den korrekte sti til avr-objdump baseret på operativsystem
        if(CMAKE_HOST_WIN32)
            set(_objdump_path "c:/Program Files/Microchip/xc8/v4.00/bin/avr-objdump.exe")
        else()
            # Linux-sti (tilpas evt. hvis XC8 er installeret et andet sted på Linux)
            set(_objdump_path "/opt/microchip/xc8/v4.00/bin/avr-objdump")
        endif()

        # Kør den fungerende kommando direkte med den korrekte værktøjssti
        add_custom_command(
            TARGET ${_target} POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E echo "Genererer assembler listefil..."
            COMMAND "${_objdump_path}" -h -S "$<TARGET_FILE:${_target}>" > "$<TARGET_FILE_DIR:${_target}>/${_target}.lst"
            COMMENT "Opretter .lst fil ved siden af .elf-filen"
            VERBATIM
        )
    endif()
endforeach()