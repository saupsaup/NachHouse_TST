// Stav valid·cie generovanej schÈmy ; Validation state for the generated schema.
VAR_GLOBAL
  SchOk    : BOOL := FALSE;  // TRUE aû po ˙speönej kontrole celej tabuæky schÈmy ; TRUE only after the entire schema table passes validation.
  SchErr   : USINT := 0;     // KÛd prvej chyby zisten˝ pri kontrole schÈmy ; First error code detected during schema validation.
  SchState : USINT := 0;     // Kontrola schÈmy sa vykon· raz a jej v˝sledok sa zapam‰t· ; Schema validation runs once and its result is cached. 0=new, 1=valid, 2=error
END_VAR

// Porovn· vygenerovan˙ schÈmu s aCfg a aktu·lnym rozloûenÌm mRam. ; Compare the generated schema with aCfg and the current mRam layout.
// OverÌ poËty, veækosti, uzly a rozsahy schÈmy eöte pred prevodom ; Validate schema counts, sizes, nodes, and bounds before conversion.
FUNCTION SchInit : BOOL
  VAR
    Cf       : INT;                   // Index d·tovÈho typu v aCfg/aSch ; Data-type index in aCfg/aSch.
    Nd       : UINT;                  // Index pr·ve kontrolovanÈho uzla ötrukt˙ry ; Index of the structure node being checked.
    Last     : UINT;                  // Posledn˝ uzol patriaci aktu·lnemu typu ; Last node belonging to the current type.
    Expected : UINT := 1;             // OËak·van˝ zaËiatok Ôalöieho s˙vislÈho rozsahu uzlov ; Expected start of the next contiguous node range.
    BaseTag  : USINT;                 // Z·kladn˝ typ uzla po odobratÌ prÌznaku ARRAY ; Node base type after removing the ARRAY flag. ; Z·kladn˝ typ urËuje v˝poËet prvku poæa ; The base type determines array-element addressing.
    NodeEnd  : UINT;                  // Koniec podstromu vnorenÈho STRUCT ; End of a nested STRUCT subtree.
    ElemSpan : UINT;                  // Veækosù jednÈho prvku poæa STRUCT ; Size of one STRUCT-array element.
    Depth    : USINT;                 // Aktu·lna hÂbka vnorenia pri kontrole uzlov ; Current nesting depth while validating nodes.
    EndStk   : ARRAY[0..15] OF UINT;  // Z·sobnÌk hranÌc uzlov vnoren˝ch ötrukt˙r ; Stack of node-range ends for nested structures.
    SpanStk  : ARRAY[0..15] OF UINT;  // Z·sobnÌk veækostÌ rodiËovsk˝ch pam‰ùov˝ch oblastÌ ; Stack of parent memory-span sizes.
    RamEnd   : UDINT;                 // Koniec vyhradenej oblasti typu v mRam ; End of this type's reserved region in mRam.
  END_VAR

  SchInit := FALSE;
  // Pouûije zapam‰tan˝ ˙spech bez opakovania ˙plnej kontroly ; Reuse the cached success without repeating full validation.
  IF SchState = 1 THEN SchInit := TRUE; RETURN; END_IF;
  // Po predch·dzaj˙cej chybe sa prevod bezpeËne zastavÌ ; Stop conversion after a previously detected schema error.
  IF SchState = 2 THEN RETURN; END_IF;

  SchOk := FALSE;
  SchErr := 1;
  SchState := 2;
  IF SCH_DEF_N <> INT_TO_UINT(_NH_CFG) THEN RETURN; END_IF;

  // Porovn· kaûd˝ typ schÈmy s jeho konfigur·ciou a rozloûenÌm v pam‰ti ; Compare each schema type with its configuration and memory layout.
  FOR Cf := 1 TO _NH_CFG DO
    IF aSch[Cf].Cfg <> INT_TO_USINT(Cf) THEN SchErr := 2; RETURN; END_IF;
    IF aSch[Cf].Code <> aCfg[Cf].cfg THEN SchErr := 3; RETURN; END_IF;
    IF aSch[Cf].Siz <> aCfg[Cf].Siz THEN SchErr := 4; RETURN; END_IF;
    IF (aSch[Cf].Fst <> Expected) OR (aSch[Cf].Cnt = 0) THEN SchErr := 5; RETURN; END_IF;
    Last := aSch[Cf].Fst + aSch[Cf].Cnt - 1;
    IF Last > SCH_NODE_N THEN SchErr := 6; RETURN; END_IF;
    Expected := Last + 1;

    RamEnd := aCfg[Cf].iRam + aCfg[Cf].Siz * aCfg[Cf].Rec;
    IF RamEnd > SIZEOF(mRam) THEN SchErr := 7; RETURN; END_IF;
    IF aCfg[Cf].Ram <> PTR_TO_UDINT(ADR(mRam[aCfg[Cf].iRam])) THEN SchErr := 8; RETURN; END_IF;

    Depth := 0;  // ZaËne kontrolu stromu uzlov od koreÚa aktu·lneho typu ; Start validating the node tree at the current type's root.
    EndStk[0] := Last + 1;
    SpanStk[0] := UDINT_TO_UINT(aSch[Cf].Siz);
    FOR Nd := aSch[Cf].Fst TO Last DO
      WHILE (Depth > 0) AND (Nd >= EndStk[Depth]) DO Depth := Depth - 1; END_WHILE;
      IF UINT_TO_UDINT(aNode[Nd].Ofs) + UINT_TO_UDINT(aNode[Nd].Span) > UINT_TO_UDINT(SpanStk[Depth]) THEN
        SchErr := 9; RETURN;
      END_IF;

      BaseTag := aNode[Nd].Tag MOD SCH_ARRAY;  // OddelÌ z·kladn˝ d·tov˝ typ od prÌznaku poæa ; Separate the base data type from the array flag.
      IF (BaseTag < SCH_BOOL) OR (BaseTag > SCH_STRUCT) OR (aNode[Nd].Span = 0) THEN
        SchErr := 10; RETURN;
      END_IF;

      IF aNode[Nd].Tag >= SCH_ARRAY THEN
        IF aNode[Nd].Cnt = 0 THEN SchErr := 11; RETURN; END_IF;
        IF BaseTag = SCH_STRUCT THEN
          IF (aNode[Nd].Span MOD aNode[Nd].Cnt) <> 0 THEN SchErr := 12; RETURN; END_IF;
        ELSIF BaseTag = SCH_BOOL THEN
          IF (aNode[Nd].Aux + aNode[Nd].Cnt + 7) / 8 > aNode[Nd].Span THEN SchErr := 13; RETURN; END_IF;
        ELSE
          IF (aNode[Nd].Aux = 0) OR (aNode[Nd].Aux * aNode[Nd].Cnt <> aNode[Nd].Span) THEN
            SchErr := 14; RETURN;
          END_IF;
        END_IF;
      ELSE
        IF aNode[Nd].Cnt <> 0 THEN SchErr := 15; RETURN; END_IF;
        IF (BaseTag = SCH_BOOL) AND (aNode[Nd].Aux > 7) THEN SchErr := 16; RETURN; END_IF;
      END_IF;

      IF BaseTag = SCH_STRUCT THEN
        NodeEnd := Nd + 1 + aNode[Nd].Aux;
        IF NodeEnd > EndStk[Depth] THEN SchErr := 17; RETURN; END_IF;
        IF aNode[Nd].Aux > 0 THEN
          IF Depth >= 15 THEN SchErr := 18; RETURN; END_IF;
          IF aNode[Nd].Tag >= SCH_ARRAY THEN ElemSpan := aNode[Nd].Span / aNode[Nd].Cnt;
          ELSE ElemSpan := aNode[Nd].Span;
          END_IF;
          Depth := Depth + 1;
          EndStk[Depth] := NodeEnd;
          SpanStk[Depth] := ElemSpan;
        END_IF;
      END_IF;
    END_FOR;
  END_FOR;

  IF Expected <> SCH_NODE_N + 1 THEN SchErr := 19; RETURN; END_IF;
  SchErr := 0;  // Vöetky kontroly preöli ; SchInit mÙûe povoliù prevod ; All checks passed ; SchInit may allow conversion.
  SchOk := TRUE;
  SchState := 1;
  SchInit := TRUE;
END_FUNCTION

// Vr·ti zaËiatok zvolenej vety v mRam ; Rec sa ËÌsluje od 1. ; Return the selected record's base address in mRam ; Rec is one-based.
// Vr·ti adresu vybranej vety v mRam alebo nulu pri neplatnom v˝bere ; Return the selected record's mRam address, or zero for an invalid selection.
FUNCTION SchRoot : UDINT
  VAR_INPUT
    Cf  : USINT;
    Rec : UDINT;
  END_VAR
  SchRoot := 0;
  IF NOT SchInit() THEN RETURN; END_IF;
  IF (Cf < 1) OR (Cf > UINT_TO_USINT(SCH_DEF_N)) THEN RETURN; END_IF;
  IF (Rec < 1) OR (Rec > aCfg[Cf].Rec) THEN RETURN; END_IF;
  IF NOT aCfg[Cf].Enabled OR NOT aCfg[Cf].ok THEN RETURN; END_IF;
  SchRoot := aCfg[Cf].Ram + (Rec - 1) * aCfg[Cf].Siz;
END_FUNCTION

// VypoËÌta adresu uzla v rodiËovi ; El pri poli je skutoËn˝ IEC index. ; Calculate a node address within its parent ; El is the actual IEC array index.
// VypoËÌta adresu poloûky alebo prvku poæa z rodiËovskej adresy a offsetu ; Calculate a field/array-element address from its parent and offset.
FUNCTION SchAdr : UDINT
  VAR_INPUT
    Parent : UDINT;
    Nd     : UINT;   // Index pr·ve kontrolovanÈho uzla ötrukt˙ry ; Index of the structure node being checked.
    El     : INT;
  END_VAR
  VAR
    BaseTag : USINT;  // Z·kladn˝ typ uzla po odobratÌ prÌznaku ARRAY ; Node base type after removing the ARRAY flag. ; Z·kladn˝ typ urËuje v˝poËet prvku poæa ; The base type determines array-element addressing.
    K       : UINT;   // PoradovÈ ËÌslo prvku od dolnej hranice poæa ; Zero-based element index from the array lower bound.
    BitPos  : UINT;   // Bitov· pozÌcia BOOL prvku v bajte ; Bit position of a BOOL element within its byte.
  END_VAR
  SchAdr := 0;
  IF NOT SchInit() OR (Parent = 0) OR (Nd < 1) OR (Nd > SCH_NODE_N) THEN RETURN; END_IF;
  IF aNode[Nd].Tag < SCH_ARRAY THEN
    SchAdr := Parent + UINT_TO_UDINT(aNode[Nd].Ofs);
    RETURN;
  END_IF;
  IF (El < aNode[Nd].Lo) OR (El >= aNode[Nd].Lo + UINT_TO_INT(aNode[Nd].Cnt)) THEN RETURN; END_IF;
  K := INT_TO_UINT(El - aNode[Nd].Lo);
  BaseTag := aNode[Nd].Tag MOD SCH_ARRAY;
  IF BaseTag = SCH_BOOL THEN
    BitPos := aNode[Nd].Aux + K;
    SchAdr := Parent + UINT_TO_UDINT(aNode[Nd].Ofs) + UINT_TO_UDINT(BitPos / 8);
  ELSIF BaseTag = SCH_STRUCT THEN
    SchAdr := Parent + UINT_TO_UDINT(aNode[Nd].Ofs) + UINT_TO_UDINT(K * (aNode[Nd].Span / aNode[Nd].Cnt));
  ELSE
    SchAdr := Parent + UINT_TO_UDINT(aNode[Nd].Ofs) + UINT_TO_UDINT(K * aNode[Nd].Aux);
  END_IF;
END_FUNCTION

// Vr·ti bitov˙ pozÌciu BOOL ; pri ostatn˝ch typoch vr·ti -1. ; Return the BOOL bit position, or -1 for other types.
// Vr·ti bitov˙ pozÌciu BOOL ; pri inom type vr·ti -1 ; Return a BOOL bit position, or -1 for another type.
FUNCTION SchBit : SINT
  VAR_INPUT
    Nd : UINT;  // Index pr·ve kontrolovanÈho uzla ötrukt˙ry ; Index of the structure node being checked.
    El : INT;
  END_VAR
  VAR
    K : UINT;  // PoradovÈ ËÌslo prvku od dolnej hranice poæa ; Zero-based element index from the array lower bound.
  END_VAR
  SchBit := -1;
  IF (Nd < 1) OR (Nd > SCH_NODE_N) THEN RETURN; END_IF;
  IF (aNode[Nd].Tag MOD SCH_ARRAY) <> SCH_BOOL THEN RETURN; END_IF;
  IF aNode[Nd].Tag < SCH_ARRAY THEN
    SchBit := UINT_TO_SINT(aNode[Nd].Aux);
    RETURN;
  END_IF;
  IF (El < aNode[Nd].Lo) OR (El >= aNode[Nd].Lo + UINT_TO_INT(aNode[Nd].Cnt)) THEN RETURN; END_IF;
  K := INT_TO_UINT(El - aNode[Nd].Lo);
  SchBit := UINT_TO_SINT((aNode[Nd].Aux + K) MOD 8);
END_FUNCTION

// N·jde ÔalöÌ uzol rovnakej ˙rovne a preskoËÌ vnoren˝ STRUCT. ; Find the next node at the same level, skipping a nested STRUCT.
// Vr·ti nasleduj˙ci s˙rodeneck˝ uzol a preskoËÌ vnoren˝ podstrom ; Return the next sibling node, skipping any nested subtree.
FUNCTION SchNext : UINT
  VAR_INPUT
    Nd : UINT;
  END_VAR
  SchNext := 0;
  IF (Nd < 1) OR (Nd > SCH_NODE_N) THEN RETURN; END_IF;
  IF (aNode[Nd].Tag MOD SCH_ARRAY) = SCH_STRUCT THEN SchNext := Nd + 1 + aNode[Nd].Aux;
  ELSE SchNext := Nd + 1;
  END_IF;
END_FUNCTION
