<?php

function getLicenseTerm($license, $term) {
    $licenses = getAllLicenses();
    return $licenses[$license][$term];
}

function getAllLicenses() {
    return array(
        'unknown' => array(
            'name-moodle' => 'Other',
            'name-repositorio' => '',
            'uri' => '',
        ),
        'allrightsreserved' => array(
            'name-moodle' => 'All Rights Reserved',
            'name-repositorio' => 'All Rights Reserved',
            'uri' => 'Copyright (c). All Rights Reserved',
        ),
        'public' => array(
            'name-moodle' => 'Public Domain',
            'name-repositorio' => 'CC0 1.0 Universal',
            'uri' => 'http://creativecommons.org/publicdomain/zero/1.0',
        ),
        'cc' => array(
            'name-moodle' => 'Creative Commons',
            'name-repositorio' => 'Attribution 4.0 International (CC BY 4.0)',
            'uri' => 'https://creativecommons.org/licenses/by/4.0/',
        ),
        'cc-nd' => array(
            'name-moodle' => 'Creative Commons - NoDerivs',
            'name-repositorio' => 'Attribution-NoDerivatives 4.0 International (CC BY-ND 4.0)',
            'uri' => 'https://creativecommons.org/licenses/by-nd/4.0/',
        ),
        'cc-nc-nd' => array(
            'name-moodle' => 'Creative Commons - No Commercial NoDerivs',
            'name-repositorio' => 'Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)',
            'uri' => 'https://creativecommons.org/licenses/by-nc-nd/4.0/',
        ),
        'cc-nc' => array(
            'name-moodle' => 'Creative Commons - No Commercial',
            'name-repositorio' => 'Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)',
            'uri' => 'https://creativecommons.org/licenses/by-nc/4.0/',
        ),
        'cc-nc-sa' => array(
            'name-moodle' => 'Creative Commons - No Commercial ShareAlike',
            'name-repositorio' => 'Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)',
            'uri' => 'https://creativecommons.org/licenses/by-nc-sa/4.0/'
        ),
        'cc-sa' => array(
            'name-moodle' => 'Creative Commons - ShareAlike',
            'name-repositorio' => 'Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)',
            'uri' => 'https://creativecommons.org/licenses/by-sa/4.0/',
        ),
    );
}

function licences_select_moodle() {
    $licenses = getAllLicenses();
    $select_licenses = array();
    foreach ($licenses as $key => $value) {
        $select_licenses[] = (object) array(
            'label' => $value['name-moodle'],
            'value' => $key,
        );
    }
    return $select_licenses;
}

function RetirarAcentos($frase) {
    $frase = str_replace(array("à","á","â","ã","ä","è","é","ê","ë","ì","í","î","ï","ò","ó","ô","õ","ö","ù","ú","û","ü","À","Á","Â","Ã","Ä","È","É","Ê","Ë","Ì","Í","Î","Ò","Ó","Ô","Õ","Ö","Ù","Ú","Û","Ü","ç","Ç","ñ","Ñ"),
                         array("a","a","a","a","a","e","e","e","e","i","i","i","i","o","o","o","o","o","u","u","u","u","A","A","A","A","A","E","E","E","E","I","I","I","O","O","O","O","O","U","U","U","U","c","C","n","N"), $frase);
 
    return $frase;     
}