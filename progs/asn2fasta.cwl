cwlVersion: v1.2
label: "asn2fasta"

class: CommandLineTool
baseCommand: asn2fasta
arguments: [ -nogenbank ]
inputs:
  i: 
    type: File
    inputBinding:
        prefix: -i
  type:
    type: string
    inputBinding:
        prefix: -type 
  feats:
    type: string?
    inputBinding:
        prefix: -feats
  serial: 
    type: string?
    inputBinding:
        prefix: -serial
  prots_only: 
    type: boolean?
    inputBinding:
        prefix: -prots-only
  fasta_name:
    type: string?
    inputBinding:
        prefix: -o
  nuc_fasta_name:
    type: string?
    inputBinding:
        prefix: -on
  prot_fasta_name:
    type: string?
    inputBinding:
        prefix: -op
outputs:
    fasta:
        type: File?
        outputBinding:
            glob: $(inputs.fasta_name)
    nuc_fasta:
        type: File?
        outputBinding:
            glob: $(inputs.nuc_fasta_name)
    prot_fasta:
        type: File?
        outputBinding:
            glob: $(inputs.prot_fasta_name)

    
