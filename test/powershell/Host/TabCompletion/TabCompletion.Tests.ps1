Describe "TabCompletion" -Tags CI {
    It 'Should complete Command' {
        $res = TabExpansion2 -inputScript 'Get-Com' -cursorColumn 'Get-Com'.Length 
        $res.CompletionMatches[0].CompletionText | Should be Get-Command
    }

    It 'Should complete native exe' -Skip:(!$IsWindows) {
        $res = TabExpansion2 -inputScript 'notep' -cursorColumn 'notep'.Length 
        $res.CompletionMatches[0].CompletionText | Should be notepad.exe
    }
    
    It 'Should complete dotnet method' {
        $res = TabExpansion2 -inputScript '(1).ToSt' -cursorColumn '(1).ToSt'.Length 
        $res.CompletionMatches[0].CompletionText | Should be 'ToString('
    }  
    
    It 'Should complete Magic foreach' {
        $res = TabExpansion2 -inputScript '(1..10).Fo' -cursorColumn '(1..10).Fo'.Length 
        $res.CompletionMatches[0].CompletionText | Should be 'Foreach('
    }    
    
    It 'Should complete types' {
        $res = TabExpansion2 -inputScript '[pscu' -cursorColumn '[pscu'.Length 
        $res.CompletionMatches[0].CompletionText | Should be 'pscustomobject'
    } 

    It 'Should complete namespaces' {
        $res = TabExpansion2 -inputScript 'using namespace Sys' -cursorColumn 'using namespace Sys'.Length 
        $res.CompletionMatches[0].CompletionText | Should be 'System'
    } 


    It 'Should complete format-table hashtable' {
        $res = TabExpansion2 -inputScript 'Get-ChildItem | Format-Table @{ ' -cursorColumn 'Get-ChildItem | Format-Table @{ '.Length 
        $res.CompletionMatches.Count | Should Be 5
        $res.CompletionMatches.Foreach{$_.CompletionText -in 'Label', 'Width', 'Alignment', 'Expression', 'FormatString' | Should Be $true}
    } 

    
    It 'Should complete format-* hashtable on GroupBy' -TestCases (        
        @{cmd = 'Format-Table'},
        @{cmd = 'Format-List'},
        @{cmd = 'Format-Wide'},
        @{cmd = 'Format-Custom'}
    ) {
        param($cmd)
        $res = TabExpansion2 -inputScript "Get-ChildItem | $cmd -GroupBy @{ " -cursorColumn "Get-ChildItem | $cmd -GroupBy @{ ".Length 
        $res.CompletionMatches.Count | Should Be 3
        $res.CompletionMatches.Foreach{$_.CompletionText -in 'Label', 'Expression', 'FormatString' | Should Be $true}
    } 

    It 'Should complete format-list hashtable' {
        $res = TabExpansion2 -inputScript 'Get-ChildItem | Format-List @{ ' -cursorColumn 'Get-ChildItem | Format-List @{ '.Length 
        $res.CompletionMatches.Count | Should Be 3
        $res.CompletionMatches.Foreach{$_.CompletionText -in 'Label', 'Expression', 'FormatString' | Should Be $true}
    } 

    It 'Should complete format-wide hashtable' {
        $res = TabExpansion2 -inputScript 'Get-ChildItem | Format-Wide @{ ' -cursorColumn 'Get-ChildItem | Format-Wide @{ '.Length 
        $res.CompletionMatches.Count | Should Be 2
        $res.CompletionMatches.Foreach{$_.CompletionText -in 'Expression', 'FormatString' | Should Be $true}
    } 

    It 'Should complete format-custom  hashtable' {
        $res = TabExpansion2 -inputScript 'Get-ChildItem | Format-Custom @{ ' -cursorColumn 'Get-ChildItem | Format-Custom @{ '.Length 
        $res.CompletionMatches.Count | Should Be 2
        $res.CompletionMatches.Foreach{$_.CompletionText -in 'Expression', 'Depth' | Should Be $true}
    } 
    
    It 'Should complete Select-Object  hashtable' {
        $res = TabExpansion2 -inputScript 'Get-ChildItem | Select-Object @{ ' -cursorColumn 'Get-ChildItem | Select-Object @{ '.Length 
        $res.CompletionMatches.Count | Should Be 2
        $res.CompletionMatches.Foreach{$_.CompletionText -in 'Name', 'Expression' | Should Be $true}
    }        

    It 'Should complete Sort-Object  hashtable' {
        $res = TabExpansion2 -inputScript 'Get-ChildItem | Sort-Object @{ ' -cursorColumn 'Get-ChildItem | Sort-Object @{ '.Length 
        $res.CompletionMatches.Count | Should Be 3
        $res.CompletionMatches.Foreach{$_.CompletionText -in 'Expression', 'Ascending', 'Descending' | Should Be $true}
    }    

    It 'Should complete New-Object  hashtable' {
        class X {
            $A
            $B
            $C
        }
        $res = TabExpansion2 -inputScript 'New-Object -TypeName X -Property @{ ' -cursorColumn 'New-Object -TypeName X -Property @{ '.Length 
        $res.CompletionMatches.Count | Should Be 3
        $res.CompletionMatches.Foreach{$_.CompletionText -in 'A', 'B', 'C' | Should Be $true}
    }     

    It 'Should complete keyword' -skip {
        $res = TabExpansion2 -inputScript 'using nam' -cursorColumn 'using nam'.Length 
        $res.CompletionMatches[0].CompletionText | Should be 'namespace'
    } 
}
