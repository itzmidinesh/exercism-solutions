def to_rna(dna_strand):
    translation_table = str.maketrans("GCTA", "CGAU")
    return dna_strand.translate(translation_table)
