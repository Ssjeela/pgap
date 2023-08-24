cwlVersion: v1.2
label: "tt_kmer_compare_wnode"  
doc: 'Pairwise comparison'
# File: tt_kmer_compare_wnode.cwl
class: Workflow # task type
inputs:
  kmer_cache_sqlite: File
  kmer_list: File
  dist_method: string
  minhash_signature: string
  score_method: string
outputs:
  distances:
    type: File
    outputSource: gpx_make_outputs/output_file
steps:
    submit_kmer_compare:
        run: ../progs/submit_kmer_compare_tmp_pairwise.cwl
        in:
            kmer_list: kmer_list
        out: [output]
    kmer_compare_wnode:
        run: ../progs/kmer_compare_wnode.cwl
        in:
            kmer_cache_sqlite: kmer_cache_sqlite
            kmer_list: kmer_list
            jobs: submit_kmer_compare/output
            dist_method: dist_method
            minhash_signature: minhash_signature
            score_method: score_method
        out: [outdir]  
    gpx_make_outputs:
        run: ../progs/gpx_make_outputs.cwl
        in:
            input_path: kmer_compare_wnode/outdir
            num_partitions: 
                default: 1
            output: 
                default: "distances.##.gz"
            output_glob:
                default: "distances.*.gz"
            unzip:
                default: "dont-unzip"
        out: [output_file]
