classdef TestNonlinearHydro < matlab.unittest.TestCase
    
    properties
        OriginalDefault
        testDir
        h5Dir = "hydroData"
        h5Name = 'ellipsoid.h5'
        outName = 'ellipsoid.out'
    end    
    
    methods (Access = 'public')        
        function obj = TestNonlinearHydro
            obj.testDir = fileparts(mfilename('fullpath'));
        end    
    end
    
    methods (TestMethodSetup)
        function killPlots (~)
            set(0,'DefaultFigureVisible','off');
        end
    end
    
    methods(TestClassSetup)        
        function captureVisibility(testCase)
            testCase.OriginalDefault = get(0,'DefaultFigureVisible');
        end        
        function runBemio(testCase)            
            cd(testCase.h5Dir);
            hydro = struct();
            hydro = Read_WAMIT(hydro,testCase.outName,[]);            
            hydro = Radiation_IRF(hydro,60,[],[],[],[]);
            hydro = Radiation_IRF_SS(hydro,[],[]);
            hydro = Excitation_IRF(hydro,157,[],[],[],[]);            
            Write_H5(hydro)
            cd(testCase.testDir)            
        end        
    end
    
    methods(TestMethodTeardown)
        function returnHome(testCase)
            cd(testCase.testDir)
        end
    end
    
    methods(TestClassTeardown)        
        function checkVisibilityRestored(testCase)
            set(0,'DefaultFigureVisible',testCase.OriginalDefault);
            testCase.assertEqual(get(0,'DefaultFigureVisible'),     ...
                                 testCase.OriginalDefault);
        end
    end
    
    methods(Test)        
        function testNonlinear_Hydro_ode4_Regular(testCase)
            cd(fullfile('ode4', 'Regular'))
            wecSim
        end        
        function testNonlinear_Hydro_ode4_RegularCIC(testCase)
            cd(fullfile('ode4', 'RegularCIC'))
            wecSim
        end        
        function testNonlinear_Hydro_ode45_Regular(testCase)
            cd(fullfile('ode45', 'Regular'))
            wecSim
        end        
        function testNonlinear_Hydro_ode45_RegularCIC(testCase)
            cd(fullfile('ode45', 'RegularCIC'))
            wecSim
        end        
    end    
end
