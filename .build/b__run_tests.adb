pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__run_tests.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__run_tests.adb");
pragma Suppress (Overflow_Check);
with Ada.Exceptions;

package body ada_main is

   E079 : Short_Integer; pragma Import (Ada, E079, "system__os_lib_E");
   E015 : Short_Integer; pragma Import (Ada, E015, "ada__exceptions_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__soft_links_E");
   E029 : Short_Integer; pragma Import (Ada, E029, "system__exception_table_E");
   E044 : Short_Integer; pragma Import (Ada, E044, "ada__containers_E");
   E074 : Short_Integer; pragma Import (Ada, E074, "ada__io_exceptions_E");
   E059 : Short_Integer; pragma Import (Ada, E059, "ada__strings_E");
   E061 : Short_Integer; pragma Import (Ada, E061, "ada__strings__maps_E");
   E065 : Short_Integer; pragma Import (Ada, E065, "ada__strings__maps__constants_E");
   E049 : Short_Integer; pragma Import (Ada, E049, "interfaces__c_E");
   E031 : Short_Integer; pragma Import (Ada, E031, "system__exceptions_E");
   E085 : Short_Integer; pragma Import (Ada, E085, "system__object_reader_E");
   E054 : Short_Integer; pragma Import (Ada, E054, "system__dwarf_lines_E");
   E025 : Short_Integer; pragma Import (Ada, E025, "system__soft_links__initialize_E");
   E043 : Short_Integer; pragma Import (Ada, E043, "system__traceback__symbolic_E");
   E105 : Short_Integer; pragma Import (Ada, E105, "ada__tags_E");
   E103 : Short_Integer; pragma Import (Ada, E103, "ada__streams_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "gnat_E");
   E122 : Short_Integer; pragma Import (Ada, E122, "system__file_control_block_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "system__finalization_root_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "ada__finalization_E");
   E118 : Short_Integer; pragma Import (Ada, E118, "system__file_io_E");
   E181 : Short_Integer; pragma Import (Ada, E181, "system__storage_pools_E");
   E177 : Short_Integer; pragma Import (Ada, E177, "system__finalization_masters_E");
   E172 : Short_Integer; pragma Import (Ada, E172, "ada__calendar_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "ada__text_io_E");
   E183 : Short_Integer; pragma Import (Ada, E183, "system__pool_global_E");
   E005 : Short_Integer; pragma Import (Ada, E005, "aunit_E");
   E008 : Short_Integer; pragma Import (Ada, E008, "aunit__memory_E");
   E152 : Short_Integer; pragma Import (Ada, E152, "aunit__memory__utils_E");
   E149 : Short_Integer; pragma Import (Ada, E149, "ada_containers__aunit_lists_E");
   E175 : Short_Integer; pragma Import (Ada, E175, "aunit__tests_E");
   E166 : Short_Integer; pragma Import (Ada, E166, "aunit__time_measure_E");
   E164 : Short_Integer; pragma Import (Ada, E164, "aunit__test_results_E");
   E147 : Short_Integer; pragma Import (Ada, E147, "aunit__assertions_E");
   E143 : Short_Integer; pragma Import (Ada, E143, "aunit__test_filters_E");
   E145 : Short_Integer; pragma Import (Ada, E145, "aunit__simple_test_cases_E");
   E013 : Short_Integer; pragma Import (Ada, E013, "aunit__reporter_E");
   E194 : Short_Integer; pragma Import (Ada, E194, "aunit__reporter__text_E");
   E210 : Short_Integer; pragma Import (Ada, E210, "aunit__test_cases_E");
   E200 : Short_Integer; pragma Import (Ada, E200, "aunit__test_suites_E");
   E198 : Short_Integer; pragma Import (Ada, E198, "aunit__run_E");
   E206 : Short_Integer; pragma Import (Ada, E206, "board_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "board__stone_E");
   E204 : Short_Integer; pragma Import (Ada, E204, "stone_test_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "suite_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E204 := E204 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "stone_test__finalize_spec");
      begin
         F1;
      end;
      E200 := E200 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "aunit__test_suites__finalize_spec");
      begin
         F2;
      end;
      E210 := E210 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "aunit__test_cases__finalize_spec");
      begin
         F3;
      end;
      E194 := E194 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "aunit__reporter__text__finalize_spec");
      begin
         F4;
      end;
      E143 := E143 - 1;
      E145 := E145 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "aunit__simple_test_cases__finalize_spec");
      begin
         F5;
      end;
      declare
         procedure F6;
         pragma Import (Ada, F6, "aunit__test_filters__finalize_spec");
      begin
         F6;
      end;
      E147 := E147 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "aunit__assertions__finalize_spec");
      begin
         F7;
      end;
      E164 := E164 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "aunit__test_results__finalize_spec");
      begin
         F8;
      end;
      declare
         procedure F9;
         pragma Import (Ada, F9, "aunit__tests__finalize_spec");
      begin
         E175 := E175 - 1;
         F9;
      end;
      E183 := E183 - 1;
      declare
         procedure F10;
         pragma Import (Ada, F10, "system__pool_global__finalize_spec");
      begin
         F10;
      end;
      E114 := E114 - 1;
      declare
         procedure F11;
         pragma Import (Ada, F11, "ada__text_io__finalize_spec");
      begin
         F11;
      end;
      E177 := E177 - 1;
      declare
         procedure F12;
         pragma Import (Ada, F12, "system__finalization_masters__finalize_spec");
      begin
         F12;
      end;
      declare
         procedure F13;
         pragma Import (Ada, F13, "system__file_io__finalize_body");
      begin
         E118 := E118 - 1;
         F13;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;
   pragma Favor_Top_Level (No_Param_Proc);

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      Ada.Exceptions'Elab_Spec;
      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E029 := E029 + 1;
      Ada.Containers'Elab_Spec;
      E044 := E044 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E074 := E074 + 1;
      Ada.Strings'Elab_Spec;
      E059 := E059 + 1;
      Ada.Strings.Maps'Elab_Spec;
      E061 := E061 + 1;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E065 := E065 + 1;
      Interfaces.C'Elab_Spec;
      E049 := E049 + 1;
      System.Exceptions'Elab_Spec;
      E031 := E031 + 1;
      System.Object_Reader'Elab_Spec;
      E085 := E085 + 1;
      System.Dwarf_Lines'Elab_Spec;
      E054 := E054 + 1;
      System.Os_Lib'Elab_Body;
      E079 := E079 + 1;
      System.Soft_Links.Initialize'Elab_Body;
      E025 := E025 + 1;
      E019 := E019 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E043 := E043 + 1;
      E015 := E015 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E105 := E105 + 1;
      Ada.Streams'Elab_Spec;
      E103 := E103 + 1;
      Gnat'Elab_Spec;
      E186 := E186 + 1;
      System.File_Control_Block'Elab_Spec;
      E122 := E122 + 1;
      System.Finalization_Root'Elab_Spec;
      E121 := E121 + 1;
      Ada.Finalization'Elab_Spec;
      E119 := E119 + 1;
      System.File_Io'Elab_Body;
      E118 := E118 + 1;
      System.Storage_Pools'Elab_Spec;
      E181 := E181 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E177 := E177 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E172 := E172 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E114 := E114 + 1;
      System.Pool_Global'Elab_Spec;
      E183 := E183 + 1;
      E008 := E008 + 1;
      E005 := E005 + 1;
      E152 := E152 + 1;
      E149 := E149 + 1;
      Aunit.Tests'Elab_Spec;
      E175 := E175 + 1;
      Aunit.Time_Measure'Elab_Spec;
      E166 := E166 + 1;
      Aunit.Test_Results'Elab_Spec;
      Aunit.Test_Results'Elab_Body;
      E164 := E164 + 1;
      Aunit.Assertions'Elab_Spec;
      Aunit.Assertions'Elab_Body;
      E147 := E147 + 1;
      Aunit.Test_Filters'Elab_Spec;
      Aunit.Simple_Test_Cases'Elab_Spec;
      Aunit.Simple_Test_Cases'Elab_Body;
      E145 := E145 + 1;
      Aunit.Test_Filters'Elab_Body;
      E143 := E143 + 1;
      Aunit.Reporter'Elab_Spec;
      Aunit.Reporter'Elab_Body;
      E013 := E013 + 1;
      Aunit.Reporter.Text'Elab_Spec;
      Aunit.Reporter.Text'Elab_Body;
      E194 := E194 + 1;
      Aunit.Test_Cases'Elab_Spec;
      Aunit.Test_Cases'Elab_Body;
      E210 := E210 + 1;
      Aunit.Test_Suites'Elab_Spec;
      Aunit.Test_Suites'Elab_Body;
      E200 := E200 + 1;
      E198 := E198 + 1;
      E206 := E206 + 1;
      E208 := E208 + 1;
      Stone_Test'Elab_Spec;
      Stone_Test'Elab_Body;
      E204 := E204 + 1;
      Suite'Elab_Body;
      E202 := E202 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_run_tests");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      if gnat_argc = 0 then
         gnat_argc := argc;
         gnat_argv := argv;
      end if;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /tushan/.build/ada_containers.o
   --   /tushan/.build/aunit-memory.o
   --   /tushan/.build/aunit.o
   --   /tushan/.build/aunit-io.o
   --   /tushan/.build/aunit-memory-utils.o
   --   /tushan/.build/ada_containers-aunit_lists.o
   --   /tushan/.build/aunit-tests.o
   --   /tushan/.build/aunit-time_measure.o
   --   /tushan/.build/aunit-test_results.o
   --   /tushan/.build/aunit-assertions.o
   --   /tushan/.build/aunit-options.o
   --   /tushan/.build/aunit-simple_test_cases.o
   --   /tushan/.build/aunit-test_filters.o
   --   /tushan/.build/aunit-reporter.o
   --   /tushan/.build/aunit-reporter-text.o
   --   /tushan/.build/aunit-test_cases.o
   --   /tushan/.build/aunit-test_suites.o
   --   /tushan/.build/aunit-run.o
   --   /tushan/.build/board.o
   --   /tushan/.build/board-stone.o
   --   /tushan/.build/stone_test.o
   --   /tushan/.build/suite.o
   --   /tushan/.build/run_tests.o
   --   -L/tushan/.build/
   --   -L/tushan/.build/
   --   -L/usr/lib/gcc/x86_64-linux-gnu/10/adalib/
   --   -shared
   --   -lgnat-10
   --   -ldl
--  END Object file/option list   

end ada_main;
