#Connections do not close automatically
<#
    Powershell is NET based, so all the same rules are going to apply
    If connections aren't closed, they will stay open until you close the IDE


    Disposing of connections and objects
        - All variables and objects should be disposed of
        - By not disposing objects, the memory for those objects is kept until the garbage collector runs
        - Eats up your RAM if not turned off
        - Objects are not disposed of are kept in memory until at least the closing of the IDE

        Object Reuse

        - Objects can be reused
        - When reusing objects, be careful to understand the original value is being removed
        - different objects have different scopes depending on where they are created
                
#>

function a{
    $value = Get-Item -Path "C:\"
    $value
}
$Value = "bla"

$value
a
$Value

$Value = "Something else"

$value