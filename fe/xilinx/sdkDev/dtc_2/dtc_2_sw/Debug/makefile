################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
dtc_2_sw.elf.size \

ELFCHECK += \
dtc_2_sw.elf.elfcheck \


# All Target
all: dtc_2_sw.elf secondary-outputs

# Tool invocations
dtc_2_sw.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: MicroBlaze gcc linker'
	mb-gcc -Wl,--no-relax -Wl,-T -Wl,../src/lscript.ld -L../../dtc_2_sw_bsp/microblaze_0/lib -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.50.a -mno-xl-soft-mul -o "dtc_2_sw.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

dtc_2_sw.elf.size: dtc_2_sw.elf
	@echo 'Invoking: MicroBlaze Print Size'
	mb-size dtc_2_sw.elf  |tee "dtc_2_sw.elf.size"
	@echo 'Finished building: $@'
	@echo ' '

dtc_2_sw.elf.elfcheck: dtc_2_sw.elf
	@echo 'Invoking: Xilinx ELF Check'
	elfcheck dtc_2_sw.elf -hw ../../dtc_2_ublaze_hw_platform/system.xml -pe microblaze_0  |tee "dtc_2_sw.elf.elfcheck"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) dtc_2_sw.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
