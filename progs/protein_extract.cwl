#!/usr/bin/env cwl-runner
cwlVersion: v1.2
label: "protein_extract"
class: Workflow

inputs:
  input: File
  nogenbank: boolean
  oproteins: string?
  olds2: string?
  oseqids: string?
  it: boolean?

outputs:
  proteins:
    type: File
    outputSource: protein_extract/proteins
  lds2:
    type: File
    outputSource: lds2_fix/lds2
  seqids:
    type: File
    outputSource: protein_extract/seqids

steps:
  protein_extract:
    in:
      input: input
      nogenbank: nogenbank
      oproteins: oproteins
      olds2: olds2
      oseqids: oseqids
      it: it
    out: [ proteins, lds2, seqids ]
    run:
      class: CommandLineTool
      #protein_extract -input-manifest models.mft -o proteins.asn -olds2 LDS2 -oseqids proteins.seq_ids -nogenbank
      baseCommand: protein_extract
      inputs:
        input:
          type: File
          inputBinding:
            prefix: -input
        nogenbank:
          type: boolean
          inputBinding:
            prefix: -nogenbank
        oproteins:
          type: string?
          default: "proteins.asn"
          inputBinding:
            prefix: -o
        olds2:
          type: string?
          default: "LDS2"
          inputBinding:
            prefix: -olds2
        oseqids:
          type: string?
          default: "proteins.seq_ids"
          inputBinding:
            prefix: -oseqids
        it: 
          type: boolean?
          inputBinding:
            prefix: -it

      outputs:
        proteins:
          type: File
          outputBinding:
            glob: $(inputs.oproteins)
        lds2:
          type: File
          outputBinding:
            glob: $(inputs.olds2)
        seqids:
          type: File
          outputBinding:
            glob: $(inputs.oseqids)
  lds2_fix:
    in:
      in_lds2: protein_extract/lds2
    out: [lds2]
    run:
      class: CommandLineTool
      requirements:
        InitialWorkDirRequirement:
          listing:
            - entry: $(inputs.in_lds2)
              writable: true
      baseCommand: sqlite3
      inputs:
        in_lds2:
          type: File
          inputBinding:
            position: 1
        sql:
          type: string?
          default: "update file set file_name=replace(file_name, rtrim(file_name, replace(file_name, '/', '')), '');"
          inputBinding:
            position: 2
      outputs:
        lds2:
          type: File
          outputBinding:
            glob: $(inputs.in_lds2.basename)