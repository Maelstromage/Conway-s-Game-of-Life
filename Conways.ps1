$global:Survive = 2,3
$global:Born = 3
$sleep = 0
$col = 50
$row = 25
$global:grid = New-Object 'object[,]' $col,$row
$global:color = 0
$global:cell = "@"
$global:dead = " "
function Random-Grid{
    param($col,$row)
    $global:grid = $null
    $global:grid = New-Object 'object[,]' $col,$row
    for($y=0;$y -lt $row;$y++){
        for($x=0;$x -lt $col;$x++){
            $rn = get-random -Maximum 2
            $global:grid[$x,$y] = $rn
        }
    }
}
function glider-Grid{
    param($col,$row)
    $global:grid = $null
    $global:grid = New-Object 'object[,]' $col,$row
    for($y=0;$y -lt $row;$y++){
        for($x=0;$x -lt $col;$x++){
            $global:grid[$x,$y] = 0
        }
    }
    $global:grid[1,1] = 1
    $global:grid[1,2] = 1
    $global:grid[1,3] = 1
    $global:grid[2,3] = 1
    $global:grid[3,2] = 1
}
function Display-Grid{
    #cls
    $line = ""
    for($y=0;$y -lt $row;$y++){
        for($x=0;$x -lt $col;$x++){
            if($global:grid[$x,$y] -eq 1){$line += $global:cell}
            if($global:grid[$x,$y] -eq 0){$line += $global:dead}
        }
        $line += "`r`n"
    }
    Write-host $line -NoNewline #-ForegroundColor $global:color
    $global:color += 1
    if($global:color -ge 16){$global:color = 9}
    sleep -Milliseconds $sleep
}
function Check-Neighbor{
    param([int32]$x,[int32]$y,$col,$row,[Switch]$debug)
    [int32]$totNei = 0 
    $xp = $x+1
    $xm = $x-1
    $yp = $y+1
    $ym = $y-1
    if($xp -eq $col){$xp = 0}
    if($xm -eq -1){$xm = $col-1}
    if($yp -eq $row){$yp = 0}
    if($ym -eq -1){$ym = $row-1}
    $totNei += $global:grid[$xm,$ym]
    $totNei += $global:grid[$x,$ym]
    $totNei += $global:grid[$xp,$ym]
    $totNei += $global:grid[$xm,$y]
    $totNei += $global:grid[$xp,$y]
    $totNei += $global:grid[$xm,$yp]
    $totNei += $global:grid[$x,$yp]
    $totNei += $global:grid[$xp,$yp]
    if($debug -eq $true){
        write-host "$($global:grid[$xm,$ym])$($global:grid[$x,$ym])$($global:grid[$xp,$ym])"
        write-host "$($global:grid[$xm,$y])$($global:grid[$x,$y])$($global:grid[$xp,$y])"
        write-host "$($global:grid[$xm,$yp])$($global:grid[$x,$yp])$($global:grid[$xp,$yp])"
        write-host "******"
        return "total: $totNei xp: $xp xm: $xm yp: $yp ym: $ym"
    }
    return $totNei
}
function New-Grid{
    param($row,$col)
    $newgrid = New-Object 'object[,]' $col,$row
    for($y=0;$y -lt $row;$y++){
        for($x=0;$x -lt $col;$x++){
            $totNei = Check-Neighbor -x $x -y $y -col $col -row $row
            $newgrid[$x,$y] = 0
            if($global:grid[$x,$y] -eq 0 -and 
                $totNei -eq $global:Born){$newgrid[$x,$y] = 1}
            if($global:grid[$x,$y] -eq 1 -and 
                $totNei -ge $global:Survive[0] -and $totNei -le $global:Survive[1]){$newgrid[$x,$y] = 1}
        }
    }
    $global:grid = $newgrid
}
Random-Grid -col $col -row $row
do{
    Display-Grid
    New-Grid -row $row -col $col
}while($true)

